#!/usr/bin/env zsh
set -eu

ROOT="${1:-/Users/zhengwan/Desktop/dev/semantic-router}"
cd "$ROOT"

ACCESS_FILE="$ROOT/wzh-steps/files/wzh-steps-2026-06-29-10-40/dashboard-local/dashboard-access.txt"

python - "$ACCESS_FILE" <<'PY'
import json
import sys
import urllib.error
import urllib.request
from pathlib import Path

access = {}
for line in Path(sys.argv[1]).read_text(encoding="utf-8").splitlines():
    if "=" in line:
        key, value = line.split("=", 1)
        access[key] = value

base = access["backend"]
frontend = access["url"]

def request(method, url, payload=None, token=None, timeout=20):
    data = None
    if payload is not None:
        data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, method=method)
    if payload is not None:
        req.add_header("Content-Type", "application/json")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return resp.status, resp.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read().decode("utf-8", "replace")

checks = []
status, _ = request("GET", f"{base}/healthz")
checks.append(("backend_healthz", status))

status, body = request("POST", f"{base}/api/auth/login", {
    "email": access["email"],
    "password": access["password"],
})
checks.append(("auth_login", status))
token = ""
if status == 200:
    token = json.loads(body).get("token", "")

status, _ = request("GET", f"{base}/api/auth/me", token=token)
checks.append(("auth_me", status))

status, body = request("GET", f"{base}/api/router/v1/models", token=token)
checks.append(("router_models_proxy", status))
model_ids = []
if status == 200:
    model_ids = [item.get("id") for item in json.loads(body).get("data", [])]

status, _ = request("GET", frontend)
checks.append(("frontend_root", status))

print(json.dumps({
    "checks": [{"name": name, "status": status} for name, status in checks],
    "models": model_ids,
}, ensure_ascii=False))
if any(status != 200 for _, status in checks):
    raise SystemExit(1)
PY
