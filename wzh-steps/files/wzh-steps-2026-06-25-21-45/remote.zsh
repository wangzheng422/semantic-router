#!/bin/zsh
set -euo pipefail

if [[ $# -lt 1 ]]; then
  print -u2 "usage: remote.zsh <remote-command>"
  exit 64
fi

env_file=".wzh/env.txt"
host="$(awk 'f && NF {print; exit} /^Hostname[[:space:]]*$/ {f=1}' "$env_file")"
user="$(awk 'f && NF {print; exit} /^Username[[:space:]]*$/ {f=1}' "$env_file")"
pass="$(awk 'f && NF {print; exit} /^Password[[:space:]]*$/ {f=1}' "$env_file")"

if [[ -z "$host" || -z "$user" || -z "$pass" ]]; then
  print -u2 "failed to parse VM access fields from .wzh/env.txt"
  exit 65
fi

export SSHPASS="$pass"
sshpass -e ssh \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -o ConnectTimeout=20 \
  "${user}@${host}" \
  "$@"
