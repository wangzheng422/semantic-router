#!/usr/bin/env zsh
set -eu

ROOT="${1:-/Users/zhengwan/Desktop/dev/semantic-router}"
cd "$ROOT"

eval "$(
  python - <<'PY'
from pathlib import Path
import shlex

lines = [line.strip() for line in Path(".wzh/env.txt").read_text().splitlines()]
vals = {}
for line in lines:
    if not line or line.startswith("#") or "=" not in line:
        continue
    key, value = line.split("=", 1)
    vals[key.strip()] = value.strip().strip("'\"")

def next_value_after(label: str) -> str:
    wanted = label.lower()
    for index, line in enumerate(lines):
        if line.lower() == wanted:
            for candidate in lines[index + 1:]:
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
    for index, line in enumerate(lines):
        if line.lower() == "login command":
            for candidate in lines[index + 1:]:
                if candidate.startswith("ssh "):
                    target = candidate.split()[-1]
                    host = target.split("@")[-1]
                    if "@" in target:
                        user = target.split("@", 1)[0]
                    break
        if host:
            break

hf_token = vals.get("HF_TOKEN", "")
ngc_key = vals.get("NGC_API_KEY", "")

print(f"export SSH_HOST={shlex.quote(host)}")
print(f"export SSH_USER={shlex.quote(user)}")
print(f"export SSHPASS={shlex.quote(password)}")
print(f"export HF_TOKEN={shlex.quote(hf_token)}")
print(f"export NGC_API_KEY={shlex.quote(ngc_key)}")
PY
)"
