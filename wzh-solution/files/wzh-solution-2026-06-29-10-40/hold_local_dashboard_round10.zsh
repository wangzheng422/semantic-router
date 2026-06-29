#!/usr/bin/env zsh
set -eu

ROOT="${1:-/Users/zhengwan/Desktop/dev/semantic-router}"
cd "$ROOT"

ROUND_ID="2026-06-29-10-40"
OUT_DIR="$ROOT/wzh-steps/files/wzh-steps-$ROUND_ID/dashboard-local"
SOLUTION_DIR="$ROOT/wzh-solution/files/wzh-solution-$ROUND_ID"
ACCESS_FILE="$OUT_DIR/dashboard-access.txt"
mkdir -p "$OUT_DIR"

rm -f "$OUT_DIR/auth.db" "$OUT_DIR/auth.db-shm" "$OUT_DIR/auth.db-wal"

source "$SOLUTION_DIR/remote_env.zsh" "$ROOT"

DASHBOARD_PASSWORD="$(python - <<'PY'
import secrets
print("round10-" + secrets.token_urlsafe(18))
PY
)"
DASHBOARD_JWT_SECRET="$(python - <<'PY'
import secrets
print(secrets.token_urlsafe(48))
PY
)"

{
  echo "url=http://127.0.0.1:3001"
  echo "backend=http://127.0.0.1:8700"
  echo "email=round10-admin@example.test"
  echo "password=$DASHBOARD_PASSWORD"
  echo "router_api=http://127.0.0.1:28080"
  echo "envoy_openai=http://127.0.0.1:28888/v1"
  echo "note=Temporary local demo credential for round 10 dashboard only. Do not commit this file."
} > "$ACCESS_FILE"
chmod 600 "$ACCESS_FILE"

sshpass -e ssh \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=10 \
  -o ServerAliveCountMax=3 \
  -N \
  -L 28080:127.0.0.1:18080 \
  -L 28888:127.0.0.1:18888 \
  -L 29190:127.0.0.1:19190 \
  "$SSH_USER@$SSH_HOST" \
  >"$OUT_DIR/hold-ssh-tunnel.log" 2>&1 &
TUNNEL_PID=$!

(
  cd "$ROOT/dashboard/backend"
  DASHBOARD_PORT=8700 \
  DASHBOARD_AUTH_DB_PATH="$OUT_DIR/auth.db" \
  DASHBOARD_WORKFLOW_DB_PATH="$OUT_DIR/workflow.sqlite" \
  DASHBOARD_CONFIG_PROJECTION_DB_PATH="$OUT_DIR/config-projection.sqlite" \
  DASHBOARD_JWT_SECRET="$DASHBOARD_JWT_SECRET" \
  DASHBOARD_ADMIN_EMAIL="round10-admin@example.test" \
  DASHBOARD_ADMIN_PASSWORD="$DASHBOARD_PASSWORD" \
  DASHBOARD_ADMIN_NAME="Round 10 Admin" \
  ROUTER_CONFIG_PATH="$SOLUTION_DIR/router-round10-dashboard-demo.yaml" \
  VLLM_SR_RUNTIME_CONFIG_PATH="$SOLUTION_DIR/router-round10-dashboard-demo.yaml" \
  VLLM_SR_ENVOY_CONFIG_PATH="$SOLUTION_DIR/envoy-round10-dashboard-demo.yaml" \
  TARGET_ROUTER_API_URL="http://127.0.0.1:28080" \
  TARGET_ENVOY_URL="http://127.0.0.1:28888" \
  TARGET_ROUTER_METRICS_URL="http://127.0.0.1:29190/metrics" \
  OPENCLAW_ENABLED=false \
  go run main.go
) >"$OUT_DIR/hold-dashboard-backend.log" 2>&1 &
BACKEND_PID=$!

(
  cd "$ROOT/dashboard/frontend"
  npm run dev -- --host 127.0.0.1 --port 3001
) >"$OUT_DIR/hold-dashboard-frontend.log" 2>&1 &
FRONTEND_PID=$!

cleanup() {
  kill "$FRONTEND_PID" "$BACKEND_PID" "$TUNNEL_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

wait_url() {
  local label="$1"
  local url="$2"
  local deadline=$((SECONDS + 120))
  while (( SECONDS < deadline )); do
    if curl -fsS "$url" >/dev/null 2>&1; then
      echo "$label ready: $url"
      return 0
    fi
    sleep 2
  done
  echo "$label did not become ready: $url" >&2
  return 1
}

wait_url "remote-router-through-tunnel" "http://127.0.0.1:28080/v1/models"
wait_url "dashboard-backend" "http://127.0.0.1:8700/healthz"
wait_url "dashboard-frontend" "http://127.0.0.1:3001"

echo "dashboard_url=http://127.0.0.1:3001"
echo "access_file=$ACCESS_FILE"
echo "holding dashboard processes; stop this script to tear down the local dashboard session"

wait
