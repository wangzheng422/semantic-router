#!/usr/bin/env python3
import argparse
import json
import time
from pathlib import Path

from openai import OpenAI


SCENARIOS = [
    {
        "id": "single_simple_summary",
        "messages": [
            {
                "role": "user",
                "content": "Give a short one sentence greeting for a customer support chat.",
            }
        ],
    },
    {
        "id": "single_complex_debug",
        "messages": [
            {
                "role": "user",
                "content": "Debug this distributed algorithm and explain the root cause, tradeoffs, and a benchmark plan.",
            }
        ],
    },
    {
        "id": "single_math_proof",
        "messages": [
            {
                "role": "user",
                "content": "Prove the theorem using a multi step derivation and explain each inference.",
            }
        ],
    },
    {
        "id": "single_translation",
        "messages": [
            {
                "role": "user",
                "content": "Translate only: semantic routing keeps simple requests inexpensive.",
            }
        ],
    },
]

MULTI_TURN = [
    {
        "role": "user",
        "content": "Hello, give me one short sentence welcoming a new retail customer.",
    },
    {
        "role": "user",
        "content": "Now switch topics: debug a flaky distributed queue algorithm and give the root cause and tradeoffs.",
    },
    {
        "role": "user",
        "content": "Switch again: summarize the previous answer in one short sentence.",
    },
]

CAPTURE_HEADERS = [
    "x-vsr-selected-model",
    "x-vsr-selected-decision",
    "x-vsr-selected-confidence",
    "x-vsr-selected-reasoning",
    "x-vsr-matched-keywords",
    "x-vsr-matched-domains",
    "x-vsr-matched-projections",
    "x-vsr-context-token-count",
]


def call_chat(client, model, messages, max_tokens):
    start = time.perf_counter()
    raw = client.chat.completions.with_raw_response.create(
        model=model,
        messages=messages,
        max_tokens=max_tokens,
        temperature=0,
    )
    elapsed_ms = round((time.perf_counter() - start) * 1000, 2)
    parsed = raw.parse()
    headers = {key: raw.headers.get(key) for key in CAPTURE_HEADERS}
    text = parsed.choices[0].message.content or ""
    return {
        "elapsed_ms": elapsed_ms,
        "http_status": raw.status_code,
        "response_model": parsed.model,
        "headers": headers,
        "content_preview": text[:240].replace("\n", " "),
    }, text


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
            result, _text = call_chat(
                client, args.model, scenario["messages"], args.max_tokens
            )
            result.update(
                {
                    "scenario_type": "single_turn",
                    "scenario_id": scenario["id"],
                    "turn": 1,
                    "message_count": len(scenario["messages"]),
                    "last_user": scenario["messages"][-1]["content"],
                }
            )
            out.write(json.dumps(result, ensure_ascii=False) + "\n")
            print(json.dumps(result, ensure_ascii=False), flush=True)

        conversation = [
            {
                "role": "system",
                "content": "You are a concise assistant. Answer the latest user request.",
            }
        ]
        for index, turn in enumerate(MULTI_TURN, start=1):
            conversation.append(turn)
            result, assistant_text = call_chat(
                client, args.model, conversation, args.max_tokens
            )
            result.update(
                {
                    "scenario_type": "multi_turn_topic_switch",
                    "scenario_id": "multi_turn_simple_to_complex_to_simple",
                    "turn": index,
                    "message_count": len(conversation),
                    "last_user": turn["content"],
                }
            )
            out.write(json.dumps(result, ensure_ascii=False) + "\n")
            print(json.dumps(result, ensure_ascii=False), flush=True)
            conversation.append(
                {
                    "role": "assistant",
                    "content": assistant_text[:1000],
                }
            )


if __name__ == "__main__":
    main()
