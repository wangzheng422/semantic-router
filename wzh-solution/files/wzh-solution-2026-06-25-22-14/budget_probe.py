#!/usr/bin/env python
import argparse
import json
import time
from pathlib import Path

from openai import OpenAI


CAPTURE_HEADERS = [
    "x-vsr-selected-decision",
    "x-vsr-selected-model",
    "x-vsr-selection-method",
    "x-vsr-model-selection-method",
    "x-vsr-selected-reasoning",
    "x-vsr-matched-keywords",
    "x-ratelimit-limit",
    "x-ratelimit-remaining",
    "x-ratelimit-reset",
]


def lower_headers(headers):
    return {k.lower(): v for k, v in headers.items()}


def captured(headers):
    lower = lower_headers(headers)
    return {k: lower[k] for k in CAPTURE_HEADERS if k in lower}


def run_call(client, scenario_id, messages, max_tokens, extra=None):
    body = {
        "model": "auto",
        "messages": messages,
        "max_tokens": max_tokens,
        "temperature": 0,
    }
    if extra:
        body.update(extra)

    start = time.perf_counter()
    try:
        raw = client.chat.completions.with_raw_response.create(
            **body,
            extra_headers={"x-authz-user-id": "round7-budget"},
        )
        parsed = raw.parse()
        usage = parsed.usage.model_dump() if parsed.usage else None
        return {
            "scenario_id": scenario_id,
            "ok": True,
            "elapsed_ms": round((time.perf_counter() - start) * 1000, 2),
            "request": {"body": body},
            "response": {
                "status": raw.status_code,
                "captured_headers": captured(raw.headers),
                "headers": lower_headers(raw.headers),
                "model": parsed.model,
                "usage": usage,
                "content": parsed.choices[0].message.content,
            },
        }
    except Exception as exc:
        return {
            "scenario_id": scenario_id,
            "ok": False,
            "elapsed_ms": round((time.perf_counter() - start) * 1000, 2),
            "request": {"body": body},
            "error": repr(exc),
        }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--base-url", default="http://vsr-envoy:8888/v1")
    parser.add_argument("--output", required=True)
    parser.add_argument("--mode", choices=["cost-ceiling", "request-params", "ratelimit"], required=True)
    args = parser.parse_args()

    client = OpenAI(base_url=args.base_url, api_key="EMPTY")
    if args.mode == "cost-ceiling":
        scenarios = [
            (
                "complex_debug_budget_ceiling",
                [
                    {
                        "role": "user",
                        "content": "Troubleshoot this production incident, explain the root cause, debug the architecture, and propose mitigation steps.",
                    }
                ],
                64,
                None,
            ),
            (
                "simple_default_budget_ceiling",
                [{"role": "user", "content": "Hello, answer in one short sentence."}],
                32,
                None,
            ),
        ]
    elif args.mode == "request-params":
        scenarios = [
            (
                "request_params_max_tokens_64",
                [
                    {
                        "role": "user",
                        "content": "Write a numbered list with at least ten detailed items about semantic routing budget controls.",
                    }
                ],
                64,
                None,
            ),
            (
                "request_params_blocked_logprobs",
                [{"role": "user", "content": "Say hello briefly."}],
                32,
                {"logprobs": True, "top_logprobs": 2, "n": 2},
            ),
        ]
    else:
        scenarios = [
            (
                "ratelimit_large_budget_exhausted",
                [
                    {
                        "role": "user",
                        "content": "This request should first select the expensive reasoning model, but that model has only a one-token local limiter budget.",
                    }
                ],
                32,
                None,
            )
        ]

    rows = [run_call(client, sid, messages, max_tokens, extra) for sid, messages, max_tokens, extra in scenarios]
    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", encoding="utf-8") as f:
        for row in rows:
            f.write(json.dumps(row, ensure_ascii=False, sort_keys=True) + "\n")
            h = row.get("response", {}).get("captured_headers", {})
            usage = row.get("response", {}).get("usage")
            print(row["scenario_id"], row["ok"], h, row.get("response", {}).get("model"), usage)


if __name__ == "__main__":
    main()
