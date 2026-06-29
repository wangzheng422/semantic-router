#!/usr/bin/env zsh
set -eu

if [[ $# -lt 3 ]]; then
  echo "usage: $0 <root> <local-path> <remote-path>" >&2
  exit 2
fi

ROOT="$1"
LOCAL_PATH="$2"
REMOTE_PATH="$3"
source "$ROOT/wzh-solution/files/wzh-solution-2026-06-29-10-40/remote_env.zsh" "$ROOT"

sshpass -e scp \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  "$LOCAL_PATH" \
  "$SSH_USER@$SSH_HOST:$REMOTE_PATH"
