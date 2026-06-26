#!/bin/zsh
set -euo pipefail

if [[ $# -ne 2 ]]; then
  print -u2 "usage: scp_to_vm.zsh <local-path> <remote-path>"
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
sshpass -e scp \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  "$1" \
  "${user}@${host}:$2"
