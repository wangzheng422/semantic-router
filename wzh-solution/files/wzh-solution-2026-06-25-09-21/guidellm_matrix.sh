#!/bin/sh
set -eu

MP=/var/mnt/semantic-router-bench
RESULTS="$MP/benchmarks/guidellm-results/matrix"
PY_IMAGE=docker.io/library/python:3.12-slim
ROUTER_IMAGE=ghcr.io/vllm-project/semantic-router/vllm-sr:latest

restart_router() {
  config_name="$1"
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
    "$ROUTER_IMAGE" /app/config.yaml

  i=0
  while [ "$i" -lt 60 ]; do
    if curl -fsS http://127.0.0.1:18080/health >/dev/null; then
      echo "router_ready config=$config_name attempt=$i"
      return 0
    fi
    i=$((i + 1))
    sleep 2
  done
  echo "router_failed config=$config_name" >&2
  podman logs --tail 200 vsr-router >&2 || true
  return 1
}

run_bench() {
  case_name="$1"
  target="$2"
  model="$3"
  processor="$4"

  out_dir="$RESULTS/$case_name"
  rm -rf "$out_dir"
  mkdir -p "$out_dir"
  echo "benchmark_start case=$case_name target=$target model=$model processor=$processor"

  podman run --rm \
    --network vsr-bench \
    -v "$MP/benchmarks:/benchmarks:Z" \
    "$PY_IMAGE" /bin/sh -lc \
      "PYTHONPATH=/benchmarks/guidellm-py python -m guidellm benchmark run \
      --target '$target' \
      --backend openai_http \
      --model '$model' \
      --request-format chat_completions \
      --processor '$processor' \
      --data prompt_tokens=64,prompt_tokens_stdev=8,prompt_tokens_min=16,prompt_tokens_max=128,output_tokens=32,output_tokens_stdev=4,output_tokens_min=8,output_tokens_max=64 \
      --profile concurrent \
      --rate 1 \
      --max-requests 8 \
      --warmup 0 \
      --cooldown 0 \
      --output-path /benchmarks/guidellm-results/matrix/$case_name/benchmark.json \
      --disable-console-interactive"
}

summarize() {
  python - <<'PY'
import json
import statistics
from pathlib import Path

base = Path("/var/mnt/semantic-router-bench/benchmarks/guidellm-results/matrix")
print("case,successful,errored,latency_mean_s,latency_p50_s,ttft_mean_ms,output_tps_mean,total_tps_mean")
for path in sorted(base.glob("*/benchmark.json")):
    case = path.parent.name
    report = json.loads(path.read_text())
    bench = report["benchmarks"][0]
    reqs = bench["requests"]
    ok = reqs.get("successful", [])
    err = reqs.get("errored", [])
    def mean(key):
      vals = [float(r.get(key, 0.0)) for r in ok]
      return statistics.mean(vals) if vals else 0.0
    def median(key):
      vals = [float(r.get(key, 0.0)) for r in ok]
      return statistics.median(vals) if vals else 0.0
    print(
        f"{case},{len(ok)},{len(err)},"
        f"{mean('request_latency'):.4f},"
        f"{median('request_latency'):.4f},"
        f"{mean('time_to_first_token_ms'):.2f},"
        f"{mean('output_tokens_per_second'):.2f},"
        f"{mean('tokens_per_second'):.2f}"
    )
PY
}

mkdir -p "$RESULTS"

restart_router router-basic.yaml
run_bench direct-small http://vsr-qwen35-2b:8000 qwen35-2b Qwen/Qwen3.5-2B
run_bench router-small http://vsr-envoy:8888 auto Qwen/Qwen3.5-2B

restart_router router-aggressive-large.yaml
run_bench direct-large http://vsr-qwen35-27b-fp8:8000 qwen35-27b-fp8 Qwen/Qwen3.5-27B-FP8
run_bench router-large http://vsr-envoy:8888 auto Qwen/Qwen3.5-27B-FP8

summarize
