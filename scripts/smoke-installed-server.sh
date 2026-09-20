#!/usr/bin/env bash
# Prove an installed aventure-mcp-server's transport discovery: start it holding no
# credential of its own, then require /health 200, unauthenticated /mcp 401, and a
# first-party X-Client-Secret still 401. The public server has no first-party lane, so
# that header must read as no credential at all. With AUTH_TOKEN set it also requires an
# authenticated tools/list exposing aventure_read, using the only credential a public
# user holds: a personal API key from aventure.vc sent as Authorization: Bearer and
# verified against the public API the installed server defaults to. Without AUTH_TOKEN
# that leg is reported as skipped, never as passed.
#   [AUTH_TOKEN=<personal-api-key>] scripts/smoke-installed-server.sh <path-to-aventure-mcp-server-bin>
set -euo pipefail

server_bin="${1:?usage: $0 <path-to-aventure-mcp-server-bin>}"
auth_token="${AUTH_TOKEN:-}"
port="${SMOKE_PORT:-43333}"
log="$(mktemp)"
bearer_header="$(mktemp)"
response="$(mktemp)"
config_home="$(mktemp -d)"

API_URL="" API_ENV="" AUTH_TOKEN="" \
  AVENTURE_MCP_PORT="$port" XDG_CONFIG_HOME="$config_home" \
  "$server_bin" >"$log" 2>&1 &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null || true; rm -rf "$log" "$bearer_header" "$response" "$config_home"' EXIT

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

first_party="$(curl -s -o /dev/null -w '%{http_code}' "${headers[@]}" -H "X-Client-Secret: smoke-synthetic-client-secret" -d "$request" "$base/mcp")"
[ "$first_party" = "401" ] || { echo "first-party X-Client-Secret tools/list returned $first_party; the public server must carry no first-party credential lane" >&2; exit 1; }

if [ -n "$auth_token" ]; then
  printf 'Authorization: Bearer %s\n' "$auth_token" >"$bearer_header"
  authenticated="$(curl -s -o "$response" -w '%{http_code}' "${headers[@]}" -H "@$bearer_header" -d "$request" "$base/mcp")"
  [ "$authenticated" = "200" ] || { echo "authenticated tools/list returned $authenticated; AUTH_TOKEN must be an unexpired personal API key from aventure.vc with read access" >&2; exit 1; }
  tools="$(sed -n 's/^data: //p; /^{/p' "$response")"
  grep -q '"aventure_read"' <<<"$tools" || { echo "authenticated tools/list did not expose aventure_read: $tools" >&2; exit 1; }
  authenticated_result="authenticated tools/list exposes aventure_read"
else
  authenticated_result="authenticated tools/list NOT PROVEN: set AUTH_TOKEN to a personal API key from aventure.vc"
fi

echo "mcp smoke: health=200 unauthenticated=401 first-party=401; $authenticated_result"
