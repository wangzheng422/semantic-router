#!/bin/bash
set -euo pipefail

MP=/var/mnt/semantic-router-bench
ROUND_DIR="$MP/benchmarks/round4-2026-06-25-15-25"
mkdir -p "$ROUND_DIR"

start_router() {
  local config_name="$1"
  podman rm -f vsr-router vsr-envoy >/dev/null 2>&1 || true
  podman run -d --name vsr-router \
    --network vsr-bench \
    --security-opt=label=disable \
    -p 18080:8080 \
    -p 15051:50051 \
    -p 19190:9190 \
    -e AI_BINDING=candle \
    -v "$MP/configs/$config_name:/app/config.yaml:Z" \
    -v "$MP/models:/app/models:Z" \
    -v "$MP/logs:/logs:Z" \
    ghcr.io/vllm-project/semantic-router/vllm-sr:latest /app/config.yaml
  podman run -d --name vsr-envoy \
    --network vsr-bench \
    --security-opt=label=disable \
    -p 18888:8888 \
    -p 19901:9901 \
    -v "$MP/configs/envoy-vsr.yaml:/etc/envoy/envoy.yaml:Z" \
    docker.io/envoyproxy/envoy:v1.34-latest -c /etc/envoy/envoy.yaml --log-level warn

  for i in $(seq 1 90); do
    if curl -fsS http://127.0.0.1:18080/health >/dev/null 2>&1 && \
       curl -fsS http://127.0.0.1:18888/v1/models >/dev/null 2>&1; then
      echo "router-ready config=$config_name attempt=$i"
      return 0
    fi
    sleep 2
  done
  echo "router-timeout config=$config_name"
  podman logs --tail 240 vsr-router || true
  podman logs --tail 120 vsr-envoy || true
  return 1
}

run_traffic() {
  local mode="$1"
  local output="$2"
  podman run --rm --network vsr-bench \
    --entrypoint python3 \
    -v "$MP/traffic:/traffic:Z" \
    -v "$MP/benchmarks:/benchmarks:Z" \
    docker.io/vllm/vllm-openai:latest \
    /traffic/traffic_fused_audit.py \
      --base-url http://vsr-envoy:8888/v1 \
      --model auto \
      --max-tokens 96 \
      --mode "$mode" \
      --output "$output"
}

echo "## image versions"
podman image inspect ghcr.io/vllm-project/semantic-router/vllm-sr:latest --format 'router_image={{.Id}} created={{.Created}}'
podman image inspect docker.io/vllm/vllm-openai:latest --format 'vllm_image={{.Id}} created={{.Created}}'

echo "## fused config"
start_router router-fused-signals-hybrid.yaml
run_traffic fused /benchmarks/round4-2026-06-25-15-25/fused-results.jsonl
podman logs vsr-router > "$ROUND_DIR/router-fused.log" 2>&1 || true
podman logs vsr-envoy > "$ROUND_DIR/envoy-fused.log" 2>&1 || true

echo "## session aware probe"
start_router router-session-aware-probe.yaml
run_traffic probe /benchmarks/round4-2026-06-25-15-25/session-aware-probe-results.jsonl || true
podman logs vsr-router > "$ROUND_DIR/router-session-aware.log" 2>&1 || true
podman logs vsr-envoy > "$ROUND_DIR/envoy-session-aware.log" 2>&1 || true

echo "## elo probe"
start_router router-elo-probe.yaml
run_traffic probe /benchmarks/round4-2026-06-25-15-25/elo-probe-results.jsonl || true
podman logs vsr-router > "$ROUND_DIR/router-elo.log" 2>&1 || true
podman logs vsr-envoy > "$ROUND_DIR/envoy-elo.log" 2>&1 || true

echo "## package"
cd "$MP"
tar czf "$ROUND_DIR/semantic-router-round4-results-2026-06-25-15-25.tgz" \
  configs/router-fused-signals-hybrid.yaml \
  configs/router-session-aware-probe.yaml \
  configs/router-elo-probe.yaml \
  traffic/traffic_fused_audit.py \
  benchmarks/round4-2026-06-25-15-25
ls -lh "$ROUND_DIR/semantic-router-round4-results-2026-06-25-15-25.tgz"
find "$ROUND_DIR" -maxdepth 1 -type f -printf '%f %s bytes\n' | sort
