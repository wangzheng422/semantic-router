#!/bin/sh
set -eu

MP="${MP:-/var/mnt/semantic-router-bench}"
ROUND_ID="round2-2026-06-25-10-59"
RESULT_DIR="$MP/benchmarks/$ROUND_ID"
ARCHIVE="$MP/benchmarks/semantic-router-round2-results-2026-06-25-10-59.tgz"

mkdir -p "$RESULT_DIR"

start_router() {
  config_name="$1"
  echo "## start_router config=$config_name"
  podman rm -f vsr-router >/dev/null 2>&1 || true
  podman run -d \
    --name vsr-router \
    --network vsr-bench \
    --security-opt=label=disable \
    -p 18080:8080 \
    -p 15051:50051 \
    -p 19190:9190 \
    -e AI_BINDING=candle \
    -v "$MP/configs/$config_name:/app/config.yaml:Z" \
    -v "$MP/models:/app/models:Z" \
    -v "$MP/logs:/logs:Z" \
    ghcr.io/vllm-project/semantic-router/vllm-sr:latest \
    /app/config.yaml

  ready=0
  for i in $(seq 1 90); do
    if curl -fsS http://127.0.0.1:18080/health >/dev/null 2>&1; then
      echo "router_ready_after=$i"
      ready=1
      break
    fi
    if ! podman ps --format '{{.Names}}' | grep -qx vsr-router; then
      echo "router_container_exited"
      break
    fi
    sleep 2
  done
  podman ps --format '{{.Names}} {{.Status}} {{.Ports}}' | grep -E 'vsr-router|vsr-envoy' || true
  podman logs vsr-router > "$RESULT_DIR/router-$config_name-selection-only.log" 2>&1 || true
  if [ "$ready" -ne 1 ]; then
    echo "router_failed_to_become_ready"
    tail -n 160 "$RESULT_DIR/router-$config_name-selection-only.log" || true
    return 70
  fi
  for i in $(seq 1 60); do
    if curl -fsS http://127.0.0.1:18888/v1/models >/dev/null 2>&1; then
      echo "envoy_models_ready_after=$i"
      return 0
    fi
    sleep 2
  done
  echo "envoy_models_failed_to_become_ready"
  return 71
}

summarize_jsonl() {
  input_name="$1"
  summary_name="$2"
  python3 - <<PY
import json
from collections import Counter
inp = "$RESULT_DIR/$input_name"
outp = "$RESULT_DIR/$summary_name"
rows = [json.loads(line) for line in open(inp, encoding="utf-8") if line.strip()]
selected = Counter((r.get("headers") or {}).get("x-vsr-selected-model") for r in rows)
decisions = Counter((r.get("headers") or {}).get("x-vsr-selected-decision") for r in rows)
errors = Counter(r.get("error_type") for r in rows if r.get("error_type"))
summary = {
    "input": inp,
    "rows": len(rows),
    "selected_models": dict(selected),
    "selected_decisions": dict(decisions),
    "errors": dict(errors),
    "rows_compact": [
        {
            "scenario_id": r.get("scenario_id"),
            "algorithm_keyword": r.get("algorithm_keyword"),
            "model": (r.get("headers") or {}).get("x-vsr-selected-model"),
            "decision": (r.get("headers") or {}).get("x-vsr-selected-decision"),
            "error_type": r.get("error_type"),
            "http_status": r.get("http_status"),
        }
        for r in rows
    ],
}
json.dump(summary, open(outp, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
print(json.dumps(summary, ensure_ascii=False, indent=2))
PY
}

start_router router-selection-algorithms.yaml
podman run --rm \
  --network vsr-bench \
  --security-opt=label=disable \
  -v "$MP/traffic:/traffic:Z" \
  -v "$MP/benchmarks:/benchmarks:Z" \
  --entrypoint python3 \
  docker.io/vllm/vllm-openai:latest \
  /traffic/traffic_selection_algorithms.py \
  --base-url http://vsr-envoy:8888/v1 \
  --model auto \
  --max-tokens 80 \
  --output "/benchmarks/$ROUND_ID/selection-algorithms-results.jsonl"
echo "line_count $(wc -l < "$RESULT_DIR/selection-algorithms-results.jsonl") $RESULT_DIR/selection-algorithms-results.jsonl"
sed -n '1,80p' "$RESULT_DIR/selection-algorithms-results.jsonl"
summarize_jsonl selection-algorithms-results.jsonl selection-algorithms-summary.json
podman logs vsr-router > "$RESULT_DIR/router-selection-algorithms-after-traffic.log" 2>&1 || true

tar czf "$ARCHIVE" \
  -C "$MP" \
  "benchmarks/$ROUND_ID" \
  configs/router-multisignal.yaml \
  configs/router-selection-algorithms.yaml \
  traffic/traffic_multisignal.py \
  traffic/traffic_selection_algorithms.py \
  traffic/remote_round2.sh \
  traffic/remote_selection_only.sh
ls -lh "$ARCHIVE"

start_router router-basic.yaml
echo "restored=router-basic.yaml"
