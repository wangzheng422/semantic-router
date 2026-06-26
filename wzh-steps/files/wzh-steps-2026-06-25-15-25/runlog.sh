#!/bin/zsh
set -u

if [[ $# -lt 2 ]]; then
  print -u2 "usage: runlog.sh <label> <command> [args...]"
  exit 64
fi

label="$1"
shift

: "${WZH_STEPS_MD:?WZH_STEPS_MD is required}"
: "${WZH_RAW_DIR:?WZH_RAW_DIR is required}"

mkdir -p "$WZH_RAW_DIR"

safe_label="$(print -r -- "$label" | tr -c 'A-Za-z0-9_.-' '-')"
stamp="$(date '+%Y-%m-%dT%H:%M:%S%z')"
stdout_file="$WZH_RAW_DIR/${safe_label}.stdout.txt"
stderr_file="$WZH_RAW_DIR/${safe_label}.stderr.txt"
meta_file="$WZH_RAW_DIR/${safe_label}.meta.txt"
cmd_display="$(printf '%q ' "$@")"

{
  print -r -- "timestamp=$stamp"
  print -r -- "cwd=$PWD"
  print -r -- "command=$cmd_display"
} > "$meta_file"

"$@" > "$stdout_file" 2> "$stderr_file"
exit_code=$?

stdout_bytes="$(wc -c < "$stdout_file" | tr -d ' ')"
stderr_bytes="$(wc -c < "$stderr_file" | tr -d ' ')"
stdout_lines="$(wc -l < "$stdout_file" | tr -d ' ')"
stderr_lines="$(wc -l < "$stderr_file" | tr -d ' ')"

{
  print -r -- ""
  print -r -- "### ${label}"
  print -r -- ""
  print -r -- "| Field | Value |"
  print -r -- "|---|---|"
  print -r -- "| Timestamp | ${stamp} |"
  print -r -- "| Working directory | \`${PWD}\` |"
  print -r -- "| Command | \`${cmd_display}\` |"
  print -r -- "| Exit code | ${exit_code} |"
  print -r -- "| stdout | [${safe_label}.stdout.txt](files/wzh-steps-2026-06-25-15-25/${safe_label}.stdout.txt) (${stdout_lines} lines, ${stdout_bytes} bytes) |"
  print -r -- "| stderr | [${safe_label}.stderr.txt](files/wzh-steps-2026-06-25-15-25/${safe_label}.stderr.txt) (${stderr_lines} lines, ${stderr_bytes} bytes) |"
  print -r -- "| meta | [${safe_label}.meta.txt](files/wzh-steps-2026-06-25-15-25/${safe_label}.meta.txt) |"
} >> "$WZH_STEPS_MD"

exit "$exit_code"
