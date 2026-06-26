#!/bin/bash
set -euo pipefail

MP=/var/mnt/semantic-router-bench

wait_model() {
  local name="$1"
  local url="$2"
  local attempts="$3"
  local sleep_seconds="$4"
  local out="/tmp/${name}-models.json"

  for i in $(seq 1 "$attempts"); do
    code=$(curl -s -o "$out" -w "%{http_code}" "$url" || true)
    if [ "$code" = "200" ]; then
      echo "${name} ready attempt=${i}"
      cat "$out"
      echo
      return 0
    fi
    echo "${name} not-ready attempt=${i} code=${code}"
    podman ps -a --format "{{.Names}} {{.Status}}" | grep "$name" || true
    podman logs --tail 20 "$name" 2>&1 | sed "s/^/[${name}] /" || true
    sleep "$sleep_seconds"
  done

  echo "${name} timeout"
  podman logs --tail 320 "$name" || true
  return 1
}

podman rm -f vsr-qwen35-2b vsr-qwen35-27b-fp8 >/dev/null 2>&1 || true

podman run -d \
  --name vsr-qwen35-2b \
  --network vsr-bench \
  --device nvidia.com/gpu=0 \
  --security-opt=label=disable \
  --shm-size=16g \
  --ulimit nofile=65536:65536 \
  -p 18001:8000 \
  -e HF_HOME=/data/hf-cache \
  -e VLLM_USAGE_SOURCE=semantic-router-round4 \
  -e PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True \
  -v "$MP/hf-cache:/data/hf-cache:Z" \
  -v "$MP/logs:/logs:Z" \
  docker.io/vllm/vllm-openai:latest \
  Qwen/Qwen3.5-2B \
  --served-model-name qwen35-2b \
  --host 0.0.0.0 \
  --port 8000 \
  --max-model-len 4096 \
  --gpu-memory-utilization 0.35 \
  --enforce-eager

wait_model vsr-qwen35-2b http://127.0.0.1:18001/v1/models 80 15

podman run -d \
  --name vsr-qwen35-27b-fp8 \
  --network vsr-bench \
  --device nvidia.com/gpu=1 \
  --device nvidia.com/gpu=2 \
  --security-opt=label=disable \
  --shm-size=32g \
  --ulimit nofile=65536:65536 \
  -p 18002:8000 \
  -e HF_HOME=/data/hf-cache \
  -e VLLM_USAGE_SOURCE=semantic-router-round4 \
  -e PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True \
  -v "$MP/hf-cache:/data/hf-cache:Z" \
  -v "$MP/logs:/logs:Z" \
  docker.io/vllm/vllm-openai:latest \
  Qwen/Qwen3.5-27B-FP8 \
  --served-model-name qwen35-27b-fp8 \
  --host 0.0.0.0 \
  --port 8000 \
  --max-model-len 4096 \
  --gpu-memory-utilization 0.80 \
  --tensor-parallel-size 2 \
  --enforce-eager

wait_model vsr-qwen35-27b-fp8 http://127.0.0.1:18002/v1/models 120 20

podman ps -a --format "{{.Names}} {{.Status}}"
nvidia-smi --query-gpu=index,memory.used,memory.total --format=csv,noheader
