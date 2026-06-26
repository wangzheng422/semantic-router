#!/usr/bin/env zsh
set -eu

ROOT="${1:-/Users/zhengwan/Desktop/dev/semantic-router}"
OUT_DIR="${2:-$ROOT/wzh-steps/files/wzh-steps-2026-06-26-11-11/dashboard-runtime-smoke}"
SOURCE_CONFIG_PATH="$ROOT/wzh-solution/files/wzh-solution-2026-06-26-11-11/router-p1-rag-tools-response.yaml"
TOOLS_DB_PATH="$ROOT/wzh-solution/files/wzh-solution-2026-06-26-11-11/tools_db.json"
BACKEND_PORT="${DASHBOARD_BACKEND_PORT:-8700}"
FRONTEND_PORT="${DASHBOARD_FRONTEND_PORT:-3001}"
ADMIN_EMAIL="round9-admin@example.test"
ADMIN_PASS="round9-local-test-${$}-${RANDOM}"

mkdir -p "$OUT_DIR"
cd "$ROOT"

cleanup() {
  if [[ -n "${FRONTEND_PID:-}" ]]; then
    kill "$FRONTEND_PID" >/dev/null 2>&1 || true
    wait "$FRONTEND_PID" >/dev/null 2>&1 || true
  fi
  if [[ -n "${BACKEND_PID:-}" ]]; then
    kill "$BACKEND_PID" >/dev/null 2>&1 || true
    wait "$BACKEND_PID" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT INT TERM

echo "== dashboard runtime smoke =="
echo "root=$ROOT"
echo "out_dir=$OUT_DIR"
LOCAL_CONFIG_PATH="$OUT_DIR/router-dashboard-local.yaml"
python - "$SOURCE_CONFIG_PATH" "$LOCAL_CONFIG_PATH" "$TOOLS_DB_PATH" <<'PY'
import sys
src, dst, tools = sys.argv[1:]
text = open(src, encoding="utf-8").read().replace("/app/config/tools_db.json", tools)
open(dst, "w", encoding="utf-8").write(text)
PY

echo "source_config=$SOURCE_CONFIG_PATH"
echo "local_config=$LOCAL_CONFIG_PATH"
echo "backend_port=$BACKEND_PORT"
echo "frontend_port=$FRONTEND_PORT"

echo "== backend focused unit tests =="
cd "$ROOT/dashboard/backend"
go test ./auth ./configprojection ./router ./routercontract ./workflowstore

echo "== start backend =="
rm -f "$OUT_DIR/backend.log" "$OUT_DIR/frontend.log"
(
  export DASHBOARD_AUTH_DB_PATH="$OUT_DIR/auth.db"
  export DASHBOARD_JWT_SECRET="round9-local-test-secret"
  export DASHBOARD_ADMIN_EMAIL="$ADMIN_EMAIL"
  export DASHBOARD_ADMIN_PASSWORD="$ADMIN_PASS"
  export DASHBOARD_ADMIN_NAME="Round9 Admin"
  export DASHBOARD_READONLY="true"
  export DASHBOARD_SETUP_MODE="false"
  export DASHBOARD_MCP_ENABLED="false"
  export ML_PIPELINE_ENABLED="false"
  export OPENCLAW_ENABLED="false"
  export DASHBOARD_STATIC_DIR="$ROOT/dashboard/frontend"
  export ROUTER_CONFIG_PATH="$LOCAL_CONFIG_PATH"
  export TARGET_ROUTER_API_URL="http://127.0.0.1:18080"
  export TARGET_ROUTER_METRICS_URL="http://127.0.0.1:19190/metrics"
  export TARGET_ENVOY_URL="http://127.0.0.1:18888"
  go run . -port "$BACKEND_PORT" -static "$ROOT/dashboard/frontend" -config "$LOCAL_CONFIG_PATH"
) >"$OUT_DIR/backend.log" 2>&1 &
BACKEND_PID="$!"
echo "backend_pid=$BACKEND_PID"

for attempt in {1..60}; do
  if curl -fsS "http://127.0.0.1:$BACKEND_PORT/healthz" >"$OUT_DIR/healthz.json" 2>"$OUT_DIR/healthz.stderr"; then
    echo "backend_ready_attempt=$attempt"
    break
  fi
  sleep 1
done
if [[ ! -s "$OUT_DIR/healthz.json" ]]; then
  echo "backend did not become ready"
  tail -200 "$OUT_DIR/backend.log" || true
  exit 1
fi

echo "== backend api probes =="
LOGIN_PAYLOAD="$(
  python - "$ADMIN_EMAIL" "$ADMIN_PASS" <<'PY'
import json, sys
print(json.dumps({"email": sys.argv[1], "password": sys.argv[2]}))
PY
)"
curl -fsS \
  -H "Content-Type: application/json" \
  --data "$LOGIN_PAYLOAD" \
  "http://127.0.0.1:$BACKEND_PORT/api/auth/login" >"$OUT_DIR/api-auth-login.json"
AUTH_TOKEN="$(
  python - "$OUT_DIR/api-auth-login.json" <<'PY'
import json, sys
payload = json.load(open(sys.argv[1], encoding="utf-8"))
print(payload["token"])
PY
)"
python - "$OUT_DIR/api-auth-login.json" <<'PY'
import json, sys
path = sys.argv[1]
payload = json.load(open(path, encoding="utf-8"))
payload["token"] = "[REDACTED: local dashboard smoke token]"
open(path, "w", encoding="utf-8").write(json.dumps(payload, indent=2, sort_keys=True) + "\n")
PY

curl -fsS -H "Authorization: Bearer $AUTH_TOKEN" "http://127.0.0.1:$BACKEND_PORT/api/settings" >"$OUT_DIR/api-settings.json"
curl -fsS -H "Authorization: Bearer $AUTH_TOKEN" "http://127.0.0.1:$BACKEND_PORT/api/router/config/all" >"$OUT_DIR/api-config-all.json"
curl -fsS -H "Authorization: Bearer $AUTH_TOKEN" "http://127.0.0.1:$BACKEND_PORT/api/router/config/yaml" >"$OUT_DIR/api-config-yaml.txt"
curl -fsS -H "Authorization: Bearer $AUTH_TOKEN" "http://127.0.0.1:$BACKEND_PORT/api/tools-db" >"$OUT_DIR/api-tools-db.json"
curl -fsS -I -H "Authorization: Bearer $AUTH_TOKEN" "http://127.0.0.1:$BACKEND_PORT/metrics/router" >"$OUT_DIR/metrics-router.headers"

python - "$OUT_DIR" <<'PY'
import json, pathlib, sys
out = pathlib.Path(sys.argv[1])
settings = json.loads((out / "api-settings.json").read_text())
config_all = json.loads((out / "api-config-all.json").read_text())
tools = json.loads((out / "api-tools-db.json").read_text())
yaml_text = (out / "api-config-yaml.txt").read_text()
assert settings["readonlyMode"] is True, settings
assert "global" in config_all, config_all.keys()
assert config_all["global"]["router"]["model_selection"]["enabled"] is True
assert "model_selection:" in yaml_text
assert isinstance(tools, list) and len(tools) == 2, tools
assert any(tool.get("tool", {}).get("function", {}).get("name") == "get_weather" for tool in tools), tools
print("dashboard_backend_api_assertions=PASS")
PY

echo "== start vite frontend =="
cd "$ROOT/dashboard/frontend"
npm run dev -- --host 127.0.0.1 >"$OUT_DIR/frontend.log" 2>&1 &
FRONTEND_PID="$!"
echo "frontend_pid=$FRONTEND_PID"
for attempt in {1..60}; do
  if curl -fsS "http://127.0.0.1:$FRONTEND_PORT/" >"$OUT_DIR/frontend-root.html" 2>"$OUT_DIR/frontend-root.stderr"; then
    echo "frontend_ready_attempt=$attempt"
    break
  fi
  sleep 1
done
if [[ ! -s "$OUT_DIR/frontend-root.html" ]]; then
  echo "frontend did not become ready"
  tail -200 "$OUT_DIR/frontend.log" || true
  exit 1
fi

echo "== frontend route probes =="
for route in / /config /topology /playground /monitoring /insights; do
  safe_name="${route//\//_}"
  [[ "$safe_name" == "_" ]] && safe_name="root"
  curl -fsS "http://127.0.0.1:$FRONTEND_PORT$route" >"$OUT_DIR/page-${safe_name}.html"
  python - "$OUT_DIR/page-${safe_name}.html" <<'PY'
import re, sys
path = sys.argv[1]
text = open(path, encoding="utf-8").read()
title = re.search(r"<title>(.*?)</title>", text, re.I | re.S)
root = 'id="root"' in text
script = '/src/main.tsx' in text or '/assets/' in text
print(f"{path}: title={title.group(1).strip() if title else '<missing>'} root={root} script={script} bytes={len(text)}")
assert root and script
PY
done | tee "$OUT_DIR/frontend-routes.txt"

echo "== optional browser screenshots =="
if command -v playwright >/dev/null 2>&1; then
  playwright screenshot --viewport-size=1280,900 "http://127.0.0.1:$FRONTEND_PORT/config" "$OUT_DIR/config-page.png" || true
  playwright screenshot --viewport-size=1280,900 "http://127.0.0.1:$FRONTEND_PORT/playground" "$OUT_DIR/playground-page.png" || true
else
  echo "playwright command not available"
fi

echo "== authenticated ui smoke =="
(
  export DASHBOARD_FRONTEND_URL="http://127.0.0.1:$FRONTEND_PORT"
  export DASHBOARD_UI_OUT_DIR="$OUT_DIR"
  export DASHBOARD_UI_EMAIL="$ADMIN_EMAIL"
  export DASHBOARD_UI_PASSWORD="$ADMIN_PASS"
  export PLAYWRIGHT_MODULE_PATH="$ROOT/dashboard/frontend/node_modules/playwright/index.mjs"
  node "$ROOT/wzh-solution/files/wzh-solution-2026-06-26-11-11/dashboard_ui_smoke.mjs"
)

echo "dashboard_runtime_smoke=PASS"
