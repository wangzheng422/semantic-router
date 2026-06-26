#!/usr/bin/env zsh
set -u

if [[ $# -lt 1 ]]; then
  echo "usage: runlog.zsh <label> <command> [args...]" >&2
  exit 2
fi

label="$1"
shift

steps_md="${WZH_STEPS_MD:-wzh-steps/wzh-steps-2026.06.26.11.11.md}"
raw_dir="${WZH_RAW_DIR:-wzh-steps/files/wzh-steps-2026-06-26-11-11}"
mkdir -p "$raw_dir"

safe_label="$(print -r -- "$label" | tr -cs 'A-Za-z0-9_.-' '-')"
stdout_file="$raw_dir/${safe_label}.stdout.txt"
stderr_file="$raw_dir/${safe_label}.stderr.txt"
meta_file="$raw_dir/${safe_label}.meta.txt"

redact() {
  sed -E \
    -e 's/bastion\.[A-Za-z0-9.-]+/[REDACTED: bastion hostname]/g' \
    -e 's/(cloud-user@)[A-Za-z0-9.-]+/\1[REDACTED: bastion hostname]/g' \
    -e 's/(HF_TOKEN=)hf_[A-Za-z0-9]+/\1[REDACTED: Hugging Face token]/g' \
    -e 's/(NGC_API_KEY=)[A-Za-z0-9_-]+/\1[REDACTED: NGC API key]/g' \
    -e 's/(OPENAI_API_KEY=)sk-[A-Za-z0-9_-]+/\1[REDACTED: OpenAI API key]/g' \
    -e 's/(AWS_SECRET_ACCESS_KEY=)[^[:space:]]+/\1[REDACTED: AWS secret]/g' \
    -e 's/(docker login -u[ =][^[:space:]]+ -p[ =])[^[:space:]]+/\1[REDACTED: registry password]/g' \
    -e 's/(sshpass -p )[^[:space:]]+/\1[REDACTED: ssh password]/g' \
    -e 's/(Password[[:space:]]*)[A-Za-z0-9+/=._-]+/\1[REDACTED: password]/g'
}

timestamp="$(date '+%Y-%m-%dT%H:%M:%S%z')"
cwd="$(pwd)"
quoted_cmd="$(printf '%q ' "$@")"

"$@" > >(redact > "$stdout_file") 2> >(redact > "$stderr_file")
exit_code=$?

stdout_lines="$(wc -l < "$stdout_file" | tr -d ' ')"
stderr_lines="$(wc -l < "$stderr_file" | tr -d ' ')"
stdout_bytes="$(wc -c < "$stdout_file" | tr -d ' ')"
stderr_bytes="$(wc -c < "$stderr_file" | tr -d ' ')"

{
  echo "timestamp=$timestamp"
  echo "cwd=$cwd"
  echo "command=$quoted_cmd"
  echo "exit_code=$exit_code"
  echo "stdout_file=$stdout_file"
  echo "stderr_file=$stderr_file"
  echo "stdout_lines=$stdout_lines"
  echo "stderr_lines=$stderr_lines"
  echo "stdout_bytes=$stdout_bytes"
  echo "stderr_bytes=$stderr_bytes"
} > "$meta_file"

{
  echo
  echo "### $label"
  echo
  echo "| Field | Value |"
  echo "|---|---|"
  echo "| Timestamp | $timestamp |"
  echo "| Working directory | \`$cwd\` |"
  echo "| Command | \`$quoted_cmd\` |"
  echo "| Exit code | $exit_code |"
  echo "| stdout | [${safe_label}.stdout.txt](files/wzh-steps-2026-06-26-11-11/${safe_label}.stdout.txt) (${stdout_lines} lines, ${stdout_bytes} bytes) |"
  echo "| stderr | [${safe_label}.stderr.txt](files/wzh-steps-2026-06-26-11-11/${safe_label}.stderr.txt) (${stderr_lines} lines, ${stderr_bytes} bytes) |"
  echo "| meta | [${safe_label}.meta.txt](files/wzh-steps-2026-06-26-11-11/${safe_label}.meta.txt) |"
} >> "$steps_md"

exit "$exit_code"
