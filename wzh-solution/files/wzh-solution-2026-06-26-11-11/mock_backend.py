#!/usr/bin/env python
from __future__ import annotations

import json
import os
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


LOG_PATH = os.environ.get("MOCK_LOG_PATH", "/logs/mock_requests.jsonl")


def append_log(record: dict) -> None:
    os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
    with open(LOG_PATH, "a", encoding="utf-8") as f:
        f.write(json.dumps(record, ensure_ascii=False, sort_keys=True) + "\n")


def json_response(handler: BaseHTTPRequestHandler, status: int, payload: dict, headers: dict | None = None) -> None:
    body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    handler.send_response(status)
    handler.send_header("content-type", "application/json")
    handler.send_header("content-length", str(len(body)))
    if headers:
        for key, value in headers.items():
            handler.send_header(key, value)
    handler.end_headers()
    handler.wfile.write(body)


def completion_payload(request: dict, content: str) -> dict:
    model = request.get("model", "mock-model")
    return {
        "id": f"chatcmpl-mock-{int(time.time() * 1000)}",
        "object": "chat.completion",
        "created": int(time.time()),
        "model": model,
        "choices": [
            {
                "index": 0,
                "message": {"role": "assistant", "content": content},
                "finish_reason": "stop",
            }
        ],
        "usage": {"prompt_tokens": 11, "completion_tokens": 7, "total_tokens": 18},
    }


def stream_completion(handler: BaseHTTPRequestHandler, request: dict, content: str) -> None:
    model = request.get("model", "mock-model")
    created = int(time.time())
    chunks = [
        {
            "id": f"chatcmpl-stream-{created}",
            "object": "chat.completion.chunk",
            "created": created,
            "model": model,
            "choices": [{"index": 0, "delta": {"role": "assistant"}, "finish_reason": None}],
        },
        {
            "id": f"chatcmpl-stream-{created}",
            "object": "chat.completion.chunk",
            "created": created,
            "model": model,
            "choices": [{"index": 0, "delta": {"content": content}, "finish_reason": None}],
        },
        {
            "id": f"chatcmpl-stream-{created}",
            "object": "chat.completion.chunk",
            "created": created,
            "model": model,
            "choices": [{"index": 0, "delta": {}, "finish_reason": "stop"}],
        },
    ]
    handler.send_response(200)
    handler.send_header("content-type", "text/event-stream")
    handler.send_header("cache-control", "no-cache")
    handler.end_headers()
    for chunk in chunks:
        handler.wfile.write(f"data: {json.dumps(chunk)}\n\n".encode("utf-8"))
        handler.wfile.flush()
    handler.wfile.write(b"data: [DONE]\n\n")
    handler.wfile.flush()


class Handler(BaseHTTPRequestHandler):
    server_version = "Round9MockOpenAI/1.0"

    def log_message(self, fmt: str, *args) -> None:
        append_log({"kind": "access", "path": self.path, "message": fmt % args, "ts": time.time()})

    def read_json(self) -> dict:
        length = int(self.headers.get("content-length", "0") or "0")
        raw = self.rfile.read(length) if length else b"{}"
        try:
            return json.loads(raw.decode("utf-8"))
        except Exception:
            return {"_raw": raw.decode("utf-8", errors="replace")}

    def do_GET(self) -> None:
        if self.path == "/v1/models":
            json_response(
                self,
                200,
                {
                    "object": "list",
                    "data": [
                        {"id": "qwen35-2b", "object": "model", "owned_by": "round9-mock"},
                        {"id": "qwen35-27b-fp8", "object": "model", "owned_by": "round9-mock"},
                    ],
                },
            )
            return
        if self.path == "/admin/requests":
            rows = []
            if os.path.exists(LOG_PATH):
                with open(LOG_PATH, encoding="utf-8") as f:
                    rows = [json.loads(line) for line in f if line.strip()]
            json_response(self, 200, {"count": len(rows), "data": rows})
            return
        if self.path == "/healthz":
            json_response(self, 200, {"status": "ok"})
            return
        json_response(self, 404, {"error": "not found", "path": self.path})

    def do_POST(self) -> None:
        if self.path == "/admin/reset":
            os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
            open(LOG_PATH, "w", encoding="utf-8").close()
            json_response(self, 200, {"status": "reset"})
            return

        request = self.read_json()
        selected_headers = {
            key.lower(): value
            for key, value in self.headers.items()
            if key.lower().startswith("x-") or key.lower() in {"authorization", "content-type"}
        }
        append_log(
            {
                "kind": "request",
                "path": self.path,
                "headers": selected_headers,
                "body": request,
                "ts": time.time(),
            }
        )

        if self.path == "/rag/search":
            json_response(
                self,
                200,
                {
                    "content": "ROUND9_RAG_CONTEXT: Router-injected context from mock external API.",
                    "echo": request,
                },
            )
            return

        if self.path == "/v1/chat/completions":
            content = "MOCK_BACKEND_RESPONSE"
            if request.get("stream") is True:
                stream_completion(self, request, content)
            else:
                json_response(self, 200, completion_payload(request, content), {"x-mock-backend": "called"})
            return

        json_response(self, 404, {"error": "not found", "path": self.path})


if __name__ == "__main__":
    port = int(os.environ.get("MOCK_PORT", "8000"))
    server = ThreadingHTTPServer(("0.0.0.0", port), Handler)
    print(f"mock backend listening on {port}, log={LOG_PATH}", flush=True)
    server.serve_forever()
