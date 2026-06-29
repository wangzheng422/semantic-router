#!/usr/bin/env zsh
set -eu

ROOT="${1:-/Users/zhengwan/Desktop/dev/semantic-router}"
cd "$ROOT"

ROUND_ID="2026-06-29-10-40"
OUT_DIR="$ROOT/wzh-steps/files/wzh-steps-$ROUND_ID/dashboard-local"
SOLUTION_DIR="$ROOT/wzh-solution/files/wzh-solution-$ROUND_ID"
PID_FILE="$OUT_DIR/pids.env"
ACCESS_FILE="$OUT_DIR/dashboard-access.txt"
ENV_FILE="$OUT_DIR/dashboard.env"
UID_NUM="$(id -u)"
TUNNEL_LABEL="com.vsr.round10.dashboard.tunnel"
BACKEND_LABEL="com.vsr.round10.dashboard.backend"
FRONTEND_LABEL="com.vsr.round10.dashboard.frontend"

mkdir -p "$OUT_DIR"

for label in "$FRONTEND_LABEL" "$BACKEND_LABEL" "$TUNNEL_LABEL"; do
  launchctl bootout "gui/$UID_NUM/$label" >/dev/null 2>&1 || true
done

stop_pid() {
  local name="$1"
  local pid="${2:-}"
  if [[ -n "$pid" ]] && kill -0 "$pid" >/dev/null 2>&1; then
    echo "stopping $name pid=$pid"
    kill "$pid" >/dev/null 2>&1 || true
    sleep 1
  fi
}

if [[ -f "$PID_FILE" ]]; then
  source "$PID_FILE"
  stop_pid "frontend" "${FRONTEND_PID:-}"
  stop_pid "backend" "${BACKEND_PID:-}"
  stop_pid "ssh-tunnel" "${TUNNEL_PID:-}"
fi

if lsof -ti tcp:3001 >/dev/null 2>&1; then
  echo "port 3001 is already in use; stop the old dashboard frontend or choose another port" >&2
  exit 3
fi
if lsof -ti tcp:8700 >/dev/null 2>&1; then
  echo "port 8700 is already in use; stop the old dashboard backend or choose another port" >&2
  exit 3
fi
if lsof -ti tcp:28080 >/dev/null 2>&1 || lsof -ti tcp:28888 >/dev/null 2>&1 || lsof -ti tcp:29190 >/dev/null 2>&1; then
  echo "one of tunnel ports 28080, 28888, or 29190 is already in use" >&2
  exit 3
fi

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
  echo "export PATH=$(printf '%q' "$PATH")"
  echo "export SSH_HOST=$(printf '%q' "$SSH_HOST")"
  echo "export SSH_USER=$(printf '%q' "$SSH_USER")"
  echo "export SSHPASS=$(printf '%q' "$SSHPASS")"
  echo "export DASHBOARD_PASSWORD=$(printf '%q' "$DASHBOARD_PASSWORD")"
  echo "export DASHBOARD_JWT_SECRET=$(printf '%q' "$DASHBOARD_JWT_SECRET")"
} > "$ENV_FILE"
chmod 600 "$ENV_FILE"

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

cat > "$OUT_DIR/run-tunnel.zsh" <<EOF
#!/usr/bin/env zsh
set -eu
source "$ENV_FILE"
exec sshpass -e ssh \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=10 \
  -o ServerAliveCountMax=3 \
  -N \
  -L 28080:127.0.0.1:18080 \
  -L 28888:127.0.0.1:18888 \
  -L 29190:127.0.0.1:19190 \
  "\$SSH_USER@\$SSH_HOST"
EOF

cat > "$OUT_DIR/run-backend.zsh" <<EOF
#!/usr/bin/env zsh
set -eu
source "$ENV_FILE"
cd "$ROOT/dashboard/backend"
exec env \
  DASHBOARD_PORT=8700 \
  DASHBOARD_AUTH_DB_PATH="$OUT_DIR/auth.db" \
  DASHBOARD_WORKFLOW_DB_PATH="$OUT_DIR/workflow.sqlite" \
  DASHBOARD_CONFIG_PROJECTION_DB_PATH="$OUT_DIR/config-projection.sqlite" \
  DASHBOARD_JWT_SECRET="\$DASHBOARD_JWT_SECRET" \
  DASHBOARD_ADMIN_EMAIL="round10-admin@example.test" \
  DASHBOARD_ADMIN_PASSWORD="\$DASHBOARD_PASSWORD" \
  DASHBOARD_ADMIN_NAME="Round 10 Admin" \
  ROUTER_CONFIG_PATH="$SOLUTION_DIR/router-round10-dashboard-demo.yaml" \
  VLLM_SR_RUNTIME_CONFIG_PATH="$SOLUTION_DIR/router-round10-dashboard-demo.yaml" \
  VLLM_SR_ENVOY_CONFIG_PATH="$SOLUTION_DIR/envoy-round10-dashboard-demo.yaml" \
  TARGET_ROUTER_API_URL="http://127.0.0.1:28080" \
  TARGET_ENVOY_URL="http://127.0.0.1:28888" \
  TARGET_ROUTER_METRICS_URL="http://127.0.0.1:29190/metrics" \
  OPENCLAW_ENABLED=false \
  go run main.go
EOF

cat > "$OUT_DIR/run-frontend.zsh" <<EOF
#!/usr/bin/env zsh
set -eu
cd "$ROOT/dashboard/frontend"
exec npm run dev -- --host 127.0.0.1 --port 3001
EOF

chmod 700 "$OUT_DIR/run-tunnel.zsh" "$OUT_DIR/run-backend.zsh" "$OUT_DIR/run-frontend.zsh"

write_plist() {
  local label="$1"
  local script="$2"
  local stdout="$3"
  local stderr="$4"
  local plist="$OUT_DIR/$label.plist"
  cat > "$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$label</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>$script</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$stdout</string>
  <key>StandardErrorPath</key>
  <string>$stderr</string>
</dict>
</plist>
EOF
  echo "$plist"
}

TUNNEL_PLIST="$(write_plist "$TUNNEL_LABEL" "$OUT_DIR/run-tunnel.zsh" "$OUT_DIR/ssh-tunnel.log" "$OUT_DIR/ssh-tunnel.err.log")"
BACKEND_PLIST="$(write_plist "$BACKEND_LABEL" "$OUT_DIR/run-backend.zsh" "$OUT_DIR/dashboard-backend.log" "$OUT_DIR/dashboard-backend.err.log")"
FRONTEND_PLIST="$(write_plist "$FRONTEND_LABEL" "$OUT_DIR/run-frontend.zsh" "$OUT_DIR/dashboard-frontend.log" "$OUT_DIR/dashboard-frontend.err.log")"

launchctl bootstrap "gui/$UID_NUM" "$TUNNEL_PLIST"
launchctl bootstrap "gui/$UID_NUM" "$BACKEND_PLIST"
launchctl bootstrap "gui/$UID_NUM" "$FRONTEND_PLIST"

{
  echo "TUNNEL_LABEL=$TUNNEL_LABEL"
  echo "BACKEND_LABEL=$BACKEND_LABEL"
  echo "FRONTEND_LABEL=$FRONTEND_LABEL"
} > "$PID_FILE"

wait_url() {
  local label="$1"
  local url="$2"
  local deadline=$((SECONDS + 90))
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
