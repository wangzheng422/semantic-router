#!/usr/bin/env zsh
set -eu

ROOT="${1:-/Users/zhengwan/Desktop/dev/semantic-router}"
cd "$ROOT"

eval "$(
  python - <<'PY'
from pathlib import Path
import shlex

vals = {}
lines = [line.strip() for line in Path(".wzh/env.txt").read_text().splitlines()]
for line in lines:
    if not line or line.startswith("#") or "=" not in line:
        continue
    k, v = line.split("=", 1)
    vals[k.strip()] = v.strip().strip("'\"")

def next_value_after(label):
    wanted = label.lower()
    for i, line in enumerate(lines):
        if line.lower() == wanted:
            for candidate in lines[i + 1:]:
                if candidate:
                    return candidate
    return ""

host = vals.get("SSH_HOST") or vals.get("HOST") or vals.get("VM_HOST") or next_value_after("Hostname")
user = vals.get("SSH_USER") or vals.get("USER") or next_value_after("Username") or "cloud-user"
password = (
    vals.get("SSHPASS")
    or vals.get("SSH_PASSWORD")
    or vals.get("PASSWORD")
    or next_value_after("Password")
    or next_value_after("Passwd")
)

if not host:
    for i, line in enumerate(lines):
        if line.lower() == "login command":
            for candidate in lines[i + 1:]:
                if candidate.startswith("ssh "):
                    host = candidate.split()[-1].split("@")[-1]
                    if "@" in candidate.split()[-1] and not user:
                        user = candidate.split()[-1].split("@", 1)[0]
                    break
        if host:
            break

print(f"export SSH_HOST={shlex.quote(host)}")
print(f"export SSH_USER={shlex.quote(user)}")
print(f"export SSHPASS={shlex.quote(password)}")
PY
)"

sshpass -e ssh \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -o ConnectTimeout=10 \
  -o ServerAliveInterval=5 \
  -o ServerAliveCountMax=2 \
  "$SSH_USER@$SSH_HOST" \
  'podman rm -f vsr-router vsr-envoy vsr-mock-backend 2>/dev/null || true; podman ps --format "{{.Names}} {{.Status}} {{.Ports}}"'
