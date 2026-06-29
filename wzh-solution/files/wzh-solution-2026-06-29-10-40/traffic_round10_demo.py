#!/usr/bin/env python
import argparse
import json
import sys
import time
import urllib.request
import urllib.error


def post_json(url, payload, headers=None, timeout=240):
    data = json.dumps(payload).encode('utf-8')
    req = urllib.request.Request(url, data=data, method='POST')
    req.add_header('Content-Type', 'application/json')
    for k, v in (headers or {}).items():
        req.add_header(k, v)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            body = resp.read().decode('utf-8', 'replace')
            return resp.status, dict(resp.headers), body
    except urllib.error.HTTPError as exc:
        return exc.code, dict(exc.headers), exc.read().decode('utf-8', 'replace')


def get(url, timeout=60):
    try:
        with urllib.request.urlopen(url, timeout=timeout) as resp:
            return resp.status, dict(resp.headers), resp.read().decode('utf-8', 'replace')
    except urllib.error.HTTPError as exc:
        return exc.code, dict(exc.headers), exc.read().decode('utf-8', 'replace')


def summarize_case(name, status, headers, body):
    interesting = {k.lower(): v for k, v in headers.items() if k.lower().startswith('x-vsr') or k.lower() in {'x-selected-model'}}
    print(json.dumps({
        'case': name,
        'status': status,
        'selected_model': headers.get('x-vsr-selected-model') or headers.get('X-Vsr-Selected-Model'),
        'selected_decision': headers.get('x-vsr-selected-decision') or headers.get('X-Vsr-Selected-Decision'),
        'cache_hit': headers.get('x-vsr-cache-hit') or headers.get('X-Vsr-Cache-Hit'),
        'headers': interesting,
        'body_preview': body[:600],
    }, ensure_ascii=False))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--base-url', default='http://127.0.0.1:18888/v1')
    parser.add_argument('--router-url', default='http://127.0.0.1:18080')
    args = parser.parse_args()

    cases = [
        {
            'name': 'simple_short_summary',
            'headers': {'x-user-groups': 'basic'},
            'payload': {
                'model': 'round10-dashboard-demo-auto',
                'messages': [{'role': 'user', 'content': 'Give me a short one sentence summary of semantic routing.'}],
                'max_tokens': 64,
                'temperature': 0,
            },
        },
        {
            'name': 'complex_incident_architecture',
            'headers': {'x-user-groups': 'admins,premium-support', 'x-event-type': 'payment_failed', 'x-event-severity': 'critical'},
            'payload': {
                'model': 'round10-dashboard-demo-auto',
                'messages': [{'role': 'user', 'content': 'We have a production payment incident. First explain the likely root cause, then propose a debug architecture and mitigation checklist. Include 1. diagnosis 2. recovery 3. prevention.'}],
                'max_tokens': 128,
                'temperature': 0,
            },
        },
        {
            'name': 'multi_turn_topic_switch',
            'headers': {'x-user-groups': 'premium-support'},
            'payload': {
                'model': 'round10-dashboard-demo-auto',
                'messages': [
                    {'role': 'user', 'content': 'Please reset my account preference in one sentence.'},
                    {'role': 'assistant', 'content': 'I can help with that concise account request.'},
                    {'role': 'user', 'content': 'Now switch topics: debug a distributed queue incident with root cause analysis and architecture risks.'},
                ],
                'max_tokens': 128,
                'temperature': 0,
            },
        },
    ]

    for case in cases:
        status, headers, body = post_json(f'{args.base_url}/chat/completions', case['payload'], case['headers'])
        summarize_case(case['name'], status, headers, body)
        time.sleep(1)

    # Repeat first case to make semantic-cache visible if the model response was cached.
    repeat = cases[0]
    status, headers, body = post_json(f'{args.base_url}/chat/completions', repeat['payload'], repeat['headers'])
    summarize_case('simple_short_summary_repeat', status, headers, body)

    for path in ['/v1/models', '/v1/router_replay?limit=10', '/v1/router_replay/aggregate']:
        status, headers, body = get(args.router_url + path)
        print(json.dumps({'api': path, 'status': status, 'body_preview': body[:1200]}, ensure_ascii=False))


if __name__ == '__main__':
    main()
