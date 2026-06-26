#!/usr/bin/env python
from __future__ import annotations

import argparse
import json
import time
import urllib.error
import urllib.request


def request_json(method: str, url: str, payload: dict | None = None, headers: dict | None = None, stream: bool = False):
    data = json.dumps(payload).encode("utf-8") if payload is not None else None
    req_headers = {"content-type": "application/json", "authorization": "Bearer round9-test-key"}
    req_headers.update(headers or {})
    req = urllib.request.Request(url, data=data, method=method, headers=req_headers)
    started = time.time()
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            raw_headers = dict(resp.headers.items())
            if stream:
                chunks = []
                for line in resp:
                    text = line.decode("utf-8", errors="replace").strip()
                    if text:
                        chunks.append(text)
                    if text == "data: [DONE]":
                        break
                return {
                    "ok": 200 <= resp.status < 300,
                    "status": resp.status,
                    "headers": raw_headers,
                    "body": chunks,
                    "latency_ms": round((time.time() - started) * 1000, 2),
                }
            body_bytes = resp.read()
            body_text = body_bytes.decode("utf-8", errors="replace")
            try:
                body = json.loads(body_text)
            except Exception:
                body = body_text
            return {
                "ok": 200 <= resp.status < 300,
                "status": resp.status,
                "headers": raw_headers,
                "body": body,
                "latency_ms": round((time.time() - started) * 1000, 2),
            }
    except urllib.error.HTTPError as exc:
        body_text = exc.read().decode("utf-8", errors="replace")
        try:
            body = json.loads(body_text)
        except Exception:
            body = body_text
        return {
            "ok": False,
            "status": exc.code,
            "headers": dict(exc.headers.items()),
            "body": body,
            "latency_ms": round((time.time() - started) * 1000, 2),
        }


def chat_payload(content: str, *, stream: bool = False, tools: list | None = None, messages: list | None = None) -> dict:
    payload = {
        "model": "auto",
        "messages": messages or [{"role": "user", "content": content}],
        "max_tokens": 32,
        "temperature": 0,
    }
    if stream:
        payload["stream"] = True
        payload["stream_options"] = {"include_usage": True}
    if tools is not None:
        payload["tools"] = tools
        payload["tool_choice"] = "auto"
    return payload


def tool_defs() -> list:
    return [
        {
            "type": "function",
            "function": {
                "name": "get_weather",
                "description": "Get weather",
                "parameters": {"type": "object", "properties": {"location": {"type": "string"}}},
            },
        },
        {
            "type": "function",
            "function": {
                "name": "calculate",
                "description": "Calculate",
                "parameters": {"type": "object", "properties": {"expression": {"type": "string"}}},
            },
        },
    ]


def print_record(name: str, record: dict) -> None:
    print(json.dumps({"case": name, **record}, ensure_ascii=False, sort_keys=True))


def run_fast(base_url: str) -> None:
    print_record("fast_response", request_json("POST", f"{base_url}/chat/completions", chat_payload("hello fast response")))
    print_record("mock_requests", request_json("GET", "http://127.0.0.1:18003/admin/requests"))


def run_rewrite_cache_replay(base_url: str) -> None:
    request_json("POST", "http://127.0.0.1:18003/admin/reset", {})
    headers = {"x-round9-updated": "client-value", "x-round9-delete-me": "delete-this"}
    payload = chat_payload("Please answer the ROUND9 cache prompt exactly once.")
    print_record("rewrite_cache_first", request_json("POST", f"{base_url}/chat/completions", payload, headers=headers))
    print_record("rewrite_cache_second", request_json("POST", f"{base_url}/chat/completions", payload, headers=headers))
    print_record("streaming", request_json("POST", f"{base_url}/chat/completions", chat_payload("stream this please", stream=True), stream=True))
    print_record("router_replay_list", request_json("GET", f"{base_url.replace('/v1', '')}/v1/router_replay?limit=20"))
    print_record("router_replay_aggregate", request_json("GET", f"{base_url.replace('/v1', '')}/v1/router_replay/aggregate"))
    print_record("mock_requests", request_json("GET", "http://127.0.0.1:18003/admin/requests"))


def run_p1(base_url: str) -> None:
    request_json("POST", "http://127.0.0.1:18003/admin/reset", {})
    messages_turn1 = [{"role": "user", "content": "short greeting"}]
    messages_turn2 = [
        {"role": "user", "content": "short greeting"},
        {"role": "assistant", "content": "hello"},
        {"role": "user", "content": "complex architecture debug proof with weather tool"},
    ]
    session_headers = {"x-session-id": "round9-session-switch"}
    print_record("p1_turn1_small", request_json("POST", f"{base_url}/chat/completions", chat_payload("ignored", messages=messages_turn1), headers=session_headers))
    print_record(
        "p1_turn2_large_rag_tools_switch_gate",
        request_json("POST", f"{base_url}/chat/completions", chat_payload("ignored", tools=tool_defs(), messages=messages_turn2), headers=session_headers),
    )
    print_record("response_api_probe", request_json("POST", f"{base_url.replace('/v1', '')}/v1/responses", {"model": "auto", "input": "complex architecture response api probe", "max_output_tokens": 32}, headers=session_headers))
    print_record("router_replay_list", request_json("GET", f"{base_url.replace('/v1', '')}/v1/router_replay?limit=20"))
    print_record("mock_requests", request_json("GET", "http://127.0.0.1:18003/admin/requests"))


def run_rag_only(base_url: str) -> None:
    request_json("POST", "http://127.0.0.1:18003/admin/reset", {})
    print_record(
        "rag_only_chat",
        request_json("POST", f"{base_url}/chat/completions", chat_payload("complex architecture RAG injection check")),
    )
    print_record("router_replay_list", request_json("GET", f"{base_url.replace('/v1', '')}/v1/router_replay?limit=10"))
    print_record("mock_requests", request_json("GET", "http://127.0.0.1:18003/admin/requests"))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--base-url", default="http://127.0.0.1:18888/v1")
    parser.add_argument("--mode", choices=["fast", "rewrite-cache-replay", "p1", "rag-only"], required=True)
    args = parser.parse_args()
    if args.mode == "fast":
        run_fast(args.base_url)
    elif args.mode == "rewrite-cache-replay":
        run_rewrite_cache_replay(args.base_url)
    elif args.mode == "p1":
        run_p1(args.base_url)
    else:
        run_rag_only(args.base_url)


if __name__ == "__main__":
    main()
