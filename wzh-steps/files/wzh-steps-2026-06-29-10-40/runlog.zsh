#!/usr/bin/env zsh
set -u

if [[ $# -lt 2 ]]; then
  echo "usage: $0 <label> <command> [args...]" >&2
  exit 2
fi

label="$1"
shift
base_dir="wzh-steps/files/wzh-steps-2026-06-29-10-40"
mkdir -p "$base_dir"

safe_label="${label//[^A-Za-z0-9_.-]/-}"
stdout_file="$base_dir/${safe_label}-.stdout.txt"
stderr_file="$base_dir/${safe_label}-.stderr.txt"
meta_file="$base_dir/${safe_label}-.meta.txt"

timestamp="$(date '+%Y-%m-%dT%H:%M:%S%z')"
cwd="$(pwd)"
cmd_display="$(printf '%q ' "$@")"

"$@" >"$stdout_file.tmp" 2>"$stderr_file.tmp"
exit_code=$?

python - "$stdout_file.tmp" "$stdout_file" "$stderr_file.tmp" "$stderr_file" <<'PY'
import re
import sys
from pathlib import Path

src_out, dst_out, src_err, dst_err = map(Path, sys.argv[1:])

patterns = [
    (re.compile(r"(?i)(password|passwd|secret|token|api[_-]?key|access[_-]?key)(\s*[:=]\s*)(['\"]?)[^\s'\";]+"), r"\1\2\3[REDACTED: credential]"),
    (re.compile(r"hf_[A-Za-z0-9_=-]{10,}"), "[REDACTED: hf token]"),
    (re.compile(r"eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}"), "[REDACTED: jwt]"),
    (re.compile(r"(?i)(sshpass\s+-p\s+)(\S+)"), r"\1[REDACTED: ssh password]"),
    (re.compile(r"([A-Za-z0-9._%+-]+)@((?:\d{1,3}\.){3}\d{1,3}|[A-Za-z0-9.-]+\.[A-Za-z]{2,})"), r"\1@[REDACTED: host]"),
    (re.compile(r"(?i)\b(?:[A-Za-z0-9-]+\.)+(?:opentlc\.com|sandbox[0-9]+\.opentlc\.com)\b"), "[REDACTED: host]"),
    (re.compile(r"\b(?:\d{1,3}\.){3}\d{1,3}\b"), "[REDACTED: ip]"),
]

def scrub(text: str) -> str:
    for pattern, repl in patterns:
        text = pattern.sub(repl, text)
    return text

for src, dst in [(src_out, dst_out), (src_err, dst_err)]:
    dst.write_text(scrub(src.read_text(errors="replace")), encoding="utf-8")
PY

rm -f "$stdout_file.tmp" "$stderr_file.tmp"

stdout_lines="$(wc -l < "$stdout_file" | tr -d ' ')"
stderr_lines="$(wc -l < "$stderr_file" | tr -d ' ')"
stdout_bytes="$(wc -c < "$stdout_file" | tr -d ' ')"
stderr_bytes="$(wc -c < "$stderr_file" | tr -d ' ')"

{
  echo "timestamp=$timestamp"
  echo "cwd=$cwd"
  echo "command=$cmd_display"
  echo "exit_code=$exit_code"
  echo "stdout_file=$stdout_file"
  echo "stderr_file=$stderr_file"
  echo "stdout_lines=$stdout_lines"
  echo "stderr_lines=$stderr_lines"
  echo "stdout_bytes=$stdout_bytes"
  echo "stderr_bytes=$stderr_bytes"
} > "$meta_file"

python - "$label" "$meta_file" "wzh-steps/wzh-steps-2026.06.29.10.40.md" <<'PY'
import sys
from pathlib import Path

label, meta_path, steps_path = sys.argv[1:]
meta = {}
for line in Path(meta_path).read_text().splitlines():
    if "=" in line:
        k, v = line.split("=", 1)
        meta[k] = v

steps = Path(steps_path)
rel = Path(meta_path).parent
entry = f"""
### {label}

| Field | Value |
|---|---|
| Timestamp | {meta.get('timestamp', '')} |
| Working directory | `{meta.get('cwd', '')}` |
| Command | `{meta.get('command', '')}` |
| Exit code | {meta.get('exit_code', '')} |
| stdout | [{Path(meta.get('stdout_file', '')).name}](files/wzh-steps-2026-06-29-10-40/{Path(meta.get('stdout_file', '')).name}) ({meta.get('stdout_lines', '?')} lines, {meta.get('stdout_bytes', '?')} bytes) |
| stderr | [{Path(meta.get('stderr_file', '')).name}](files/wzh-steps-2026-06-29-10-40/{Path(meta.get('stderr_file', '')).name}) ({meta.get('stderr_lines', '?')} lines, {meta.get('stderr_bytes', '?')} bytes) |
| meta | [{Path(meta_path).name}](files/wzh-steps-2026-06-29-10-40/{Path(meta_path).name}) |
"""
text = steps.read_text()
if f"### {label}\n" not in text:
    steps.write_text(text.rstrip() + "\n\n" + entry.lstrip(), encoding="utf-8")
PY

exit "$exit_code"
