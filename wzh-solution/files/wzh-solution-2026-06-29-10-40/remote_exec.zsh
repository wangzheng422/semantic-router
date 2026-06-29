#!/usr/bin/env zsh
set -eu

if [[ $# -lt 2 ]]; then
  echo "usage: $0 <root> <remote-command>" >&2
  exit 2
fi

ROOT="$1"
shift
source "$ROOT/wzh-solution/files/wzh-solution-2026-06-29-10-40/remote_env.zsh" "$ROOT"

sshpass -e ssh \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -o ConnectTimeout=20 \
  -o ServerAliveInterval=10 \
  -o ServerAliveCountMax=3 \
  "$SSH_USER@$SSH_HOST" \
  "$@"
