#!/usr/bin/env bash
# Prove an installed aventure-mcp-server's transport discovery without any real
# credential or backend: start it against an unreachable loopback API with a
# synthetic client secret, then require /health 200, unauthenticated /mcp 401,
# and an authenticated tools/list that exposes aventure_read.
#   scripts/smoke-installed-server.sh <path-to-aventure-mcp-server-bin>
set -euo pipefail

server_bin="${1:?usage: $0 <path-to-aventure-mcp-server-bin>}"
port="${SMOKE_PORT:-43333}"
secret="smoke-synthetic-client-secret"
log="$(mktemp)"
config_home="$(mktemp -d)"

API_URL="127.0.0.1:9" API_ENV="" CLIENT_SECRET="$secret" ADMIN_API_KEY="" \
  AVENTURE_MCP_PORT="$port" XDG_CONFIG_HOME="$config_home" \
  "$server_bin" >"$log" 2>&1 &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null || true; rm -rf "$log" "$config_home"' EXIT

for _ in $(seq 1 100); do
  grep -q "listening" "$log" && break
  kill -0 "$server_pid" 2>/dev/null || { cat "$log" >&2; exit 1; }
  sleep 0.2
done
grep -q "listening" "$log" || { echo "server did not start" >&2; cat "$log" >&2; exit 1; }

base="http://127.0.0.1:$port"
request='{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
headers=(-H "Content-Type: application/json" -H "Accept: application/json, text/event-stream")

health="$(curl -s -o /dev/null -w '%{http_code}' "$base/health")"
[ "$health" = "200" ] || { echo "health returned $health" >&2; exit 1; }

unauthenticated="$(curl -s -o /dev/null -w '%{http_code}' "${headers[@]}" -d "$request" "$base/mcp")"
[ "$unauthenticated" = "401" ] || { echo "unauthenticated tools/list returned $unauthenticated" >&2; exit 1; }

tools="$(curl -sf "${headers[@]}" -H "X-Client-Secret: $secret" -d "$request" "$base/mcp" | sed -n 's/^data: //p; /^{/p')"
grep -q '"aventure_read"' <<<"$tools" || { echo "authenticated tools/list did not expose aventure_read: $tools" >&2; exit 1; }

echo "mcp smoke: health=200 unauthenticated=401 authenticated tools/list exposes aventure_read"
