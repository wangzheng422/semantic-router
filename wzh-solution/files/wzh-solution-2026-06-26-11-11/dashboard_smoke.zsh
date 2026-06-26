#!/usr/bin/env zsh
set -eu

ROOT="${1:-/Users/zhengwan/Desktop/dev/semantic-router}"
OUT_DIR="${2:-$ROOT/wzh-steps/files/wzh-steps-2026-06-26-11-11/dashboard-smoke}"
CONFIG_PATH="$ROOT/wzh-solution/files/wzh-solution-2026-06-26-11-11/router-p1-rag-tools-response.yaml"
PORT="${DASHBOARD_SMOKE_PORT:-18700}"

mkdir -p "$OUT_DIR"
cd "$ROOT"

echo "== dashboard smoke =="
echo "root=$ROOT"
echo "out_dir=$OUT_DIR"
echo "config=$CONFIG_PATH"
echo "port=$PORT"
echo "node=$(command -v node || true)"
echo "npm=$(command -v npm || true)"
echo "go=$(command -v go || true)"
echo "npx=$(command -v npx || true)"

cleanup() {
  if [[ -n "${DASHBOARD_PID:-}" ]]; then
    kill "$DASHBOARD_PID" >/dev/null 2>&1 || true
    wait "$DASHBOARD_PID" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT INT TERM

echo "== frontend dependency install =="
cd "$ROOT/dashboard/frontend"
if [[ -d node_modules ]]; then
  echo "node_modules already present"
else
  npm ci
fi

echo "== frontend build =="
npm run build

echo "== backend unit tests =="
cd "$ROOT/dashboard/backend"
go test ./...

echo "== backend start =="
rm -f "$OUT_DIR/dashboard.log"
(
  export DASHBOARD_AUTH_DB_PATH="$OUT_DIR/auth.db"
  export DASHBOARD_JWT_SECRET="round9-local-test-secret"
  export DASHBOARD_READONLY="true"
  export DASHBOARD_SETUP_MODE="false"
  export DASHBOARD_MCP_ENABLED="false"
  export ML_PIPELINE_ENABLED="false"
  export OPENCLAW_ENABLED="false"
  export DASHBOARD_STATIC_DIR="$ROOT/dashboard/frontend/dist"
  export ROUTER_CONFIG_PATH="$CONFIG_PATH"
  export TARGET_ROUTER_API_URL="http://127.0.0.1:18080"
  export TARGET_ROUTER_METRICS_URL="http://127.0.0.1:19190/metrics"
  export TARGET_ENVOY_URL="http://127.0.0.1:18888"
  go run . -port "$PORT" -static "$ROOT/dashboard/frontend/dist" -config "$CONFIG_PATH"
) >"$OUT_DIR/dashboard.log" 2>&1 &
DASHBOARD_PID="$!"

echo "dashboard_pid=$DASHBOARD_PID"
for attempt in {1..60}; do
  if curl -fsS "http://127.0.0.1:$PORT/healthz" >"$OUT_DIR/healthz.json" 2>"$OUT_DIR/healthz.stderr"; then
    echo "healthz_ready_attempt=$attempt"
    break
  fi
  sleep 1
done

if [[ ! -s "$OUT_DIR/healthz.json" ]]; then
  echo "dashboard did not become ready"
  tail -200 "$OUT_DIR/dashboard.log" || true
  exit 1
fi

echo "== api probes =="
curl -fsS "http://127.0.0.1:$PORT/api/settings" >"$OUT_DIR/api-settings.json"
curl -fsS "http://127.0.0.1:$PORT/api/router/config/all" >"$OUT_DIR/api-config-all.json"
curl -fsS "http://127.0.0.1:$PORT/api/router/config/yaml" >"$OUT_DIR/api-config-yaml.txt"
curl -fsS "http://127.0.0.1:$PORT/api/tools-db" >"$OUT_DIR/api-tools-db.json"
curl -fsS -I "http://127.0.0.1:$PORT/metrics/router" >"$OUT_DIR/metrics-router.headers"

echo "== spa route probes =="
for route in / /config /topology /playground /monitoring /insights; do
  safe_name="${route//\//_}"
  [[ "$safe_name" == "_" ]] && safe_name="root"
  curl -fsS "http://127.0.0.1:$PORT$route" >"$OUT_DIR/page-${safe_name}.html"
  python - "$OUT_DIR/page-${safe_name}.html" <<'PY'
import re, sys
path = sys.argv[1]
text = open(path, encoding="utf-8").read()
title = re.search(r"<title>(.*?)</title>", text, re.I | re.S)
root = 'id="root"' in text
print(f"{path}: title={title.group(1).strip() if title else '<missing>'} root={root} bytes={len(text)}")
PY
done | tee "$OUT_DIR/spa-routes.txt"

echo "== lightweight api assertions =="
python - "$OUT_DIR" <<'PY'
import json, pathlib, sys, yaml
out = pathlib.Path(sys.argv[1])
settings = json.loads((out / "api-settings.json").read_text())
config_all = json.loads((out / "api-config-all.json").read_text())
tools = json.loads((out / "api-tools-db.json").read_text())
raw_yaml = yaml.safe_load((out / "api-config-yaml.txt").read_text())

assert settings["readonly"] is True, settings
assert "config" in config_all and "global" in config_all["config"], config_all.keys()
assert config_all["config"]["global"]["router"]["model_selection"]["enabled"] is True
assert raw_yaml["global"]["router"]["model_selection"]["enabled"] is True
assert isinstance(tools, list) and len(tools) == 2, tools
assert any(tool.get("name") == "get_weather" for tool in tools), tools
print("dashboard_api_assertions=PASS")
PY

echo "dashboard_smoke=PASS"
