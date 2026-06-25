#!/usr/bin/env python3
import argparse
import json
import time
from pathlib import Path

from openai import OpenAI


CAPTURE_HEADERS = [
    "x-vsr-selected-model",
    "x-vsr-selected-decision",
    "x-vsr-selected-confidence",
    "x-vsr-selected-reasoning",
    "x-vsr-matched-keywords",
    "x-vsr-session-phase",
]


SCENARIOS = [
    {
        "id": "routerdc_simple",
        "keyword": "ALGORITHM_ROUTERDC",
        "content": "ALGORITHM_ROUTERDC Give a concise customer support reply about resetting a password.",
    },
    {
        "id": "routerdc_complex",
        "keyword": "ALGORITHM_ROUTERDC",
        "content": "ALGORITHM_ROUTERDC Analyze a distributed checkout failure and compare mitigation tradeoffs.",
    },
    {
        "id": "automix_simple",
        "keyword": "ALGORITHM_AUTOMIX",
        "content": "ALGORITHM_AUTOMIX Give one sentence about semantic routing.",
    },
    {
        "id": "automix_complex",
        "keyword": "ALGORITHM_AUTOMIX",
        "content": "ALGORITHM_AUTOMIX Debug a flaky distributed queue and explain root cause tradeoffs.",
    },
    {
        "id": "hybrid_simple",
        "keyword": "ALGORITHM_HYBRID",
        "content": "ALGORITHM_HYBRID Summarize semantic routing in one short sentence.",
    },
    {
        "id": "hybrid_complex",
        "keyword": "ALGORITHM_HYBRID",
        "content": "ALGORITHM_HYBRID Design an incident-analysis plan with risks, evidence, and rollback criteria.",
    },
    {
        "id": "multi_factor_simple",
        "keyword": "ALGORITHM_MULTIFACTOR",
        "content": "ALGORITHM_MULTIFACTOR Reply briefly to a customer asking for a greeting.",
    },
    {
        "id": "multi_factor_complex",
        "keyword": "ALGORITHM_MULTIFACTOR",
        "content": "ALGORITHM_MULTIFACTOR Compare quality, latency, cost, and load for a production routing policy.",
    },
    {
        "id": "latency_simple",
        "keyword": "ALGORITHM_LATENCY",
        "content": "ALGORITHM_LATENCY Give a short account-support answer.",
    },
    {
        "id": "latency_complex",
        "keyword": "ALGORITHM_LATENCY",
        "content": "ALGORITHM_LATENCY Produce a careful troubleshooting plan for intermittent payment failures.",
    },
]


def call_chat(client, model, messages, max_tokens, session_id):
    start = time.perf_counter()
    try:
        raw = client.chat.completions.with_raw_response.create(
            model=model,
            messages=messages,
            max_tokens=max_tokens,
            temperature=0,
            extra_headers={"x-session-id": session_id},
        )
        elapsed_ms = round((time.perf_counter() - start) * 1000, 2)
        parsed = raw.parse()
        text = parsed.choices[0].message.content or ""
        return {
            "elapsed_ms": elapsed_ms,
            "http_status": raw.status_code,
            "response_model": parsed.model,
            "headers": {key: raw.headers.get(key) for key in CAPTURE_HEADERS},
            "content_preview": text[:240].replace("\n", " "),
        }, text
    except Exception as exc:
        elapsed_ms = round((time.perf_counter() - start) * 1000, 2)
        response = getattr(exc, "response", None)
        headers = getattr(response, "headers", {}) if response is not None else {}
        return {
            "elapsed_ms": elapsed_ms,
            "http_status": getattr(exc, "status_code", None),
            "error_type": type(exc).__name__,
            "error": str(exc)[:800],
            "headers": {key: headers.get(key) for key in CAPTURE_HEADERS},
            "content_preview": "",
        }, ""


def write_result(out, result):
    out.write(json.dumps(result, ensure_ascii=False) + "\n")
    print(json.dumps(result, ensure_ascii=False), flush=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--base-url", default="http://vsr-envoy:8888/v1")
    parser.add_argument("--api-key", default="EMPTY")
    parser.add_argument("--model", default="auto")
    parser.add_argument("--max-tokens", type=int, default=96)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    client = OpenAI(base_url=args.base_url, api_key=args.api_key)
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with output_path.open("w", encoding="utf-8") as out:
        for scenario in SCENARIOS:
            messages = [{"role": "user", "content": scenario["content"]}]
            result, _text = call_chat(
                client,
                args.model,
                messages,
                args.max_tokens,
                session_id=f"round2-alg-{scenario['id']}",
            )
            result.update(
                {
                    "scenario_type": "single_turn_algorithm",
                    "scenario_id": scenario["id"],
                    "algorithm_keyword": scenario["keyword"],
                    "turn": 1,
                    "last_user": scenario["content"],
                }
            )
            write_result(out, result)


if __name__ == "__main__":
    main()
