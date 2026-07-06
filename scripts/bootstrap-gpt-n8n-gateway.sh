#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

COMPOSE=(docker compose -f infra/docker-compose.yml -f infra/docker-compose.gpt-gateway.yml --env-file infra/.env)

rand_hex() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex "$1"
  else
    date +%s%N | sha256sum | awk '{print $1}'
  fi
}

upsert_env() {
  local key="$1"
  local value="$2"
  if grep -q "^${key}=" infra/.env 2>/dev/null; then
    return 0
  fi
  printf "\n%s=%s\n" "$key" "$value" >> infra/.env
}

echo "===== N3XUS GPT → N8N GATEWAY BOOTSTRAP ====="
echo "ROOT=$ROOT_DIR"
echo

echo "===== CHECK BASE ENV ====="
if [ ! -f infra/.env ]; then
  echo "infra/.env not found. Creating from infra/.env.example first."
  cp infra/.env.example infra/.env
  chmod 600 infra/.env || true
fi

upsert_env "GPT_GATEWAY_PORT" "8787"
upsert_env "GPT_GATEWAY_API_KEY" "$(rand_hex 32)"
upsert_env "GPT_GATEWAY_REQUIRE_AUTH" "true"
upsert_env "N8N_BASE_URL" "http://n8n:5678"
upsert_env "N8N_API_KEY" "change-me-n8n-api-key-after-ui-setup"

echo "OK gateway env keys present"
echo

echo "===== VALIDATE COMPOSE WITH GATEWAY ====="
"${COMPOSE[@]}" config >/tmp/nvf-gpt-gateway-compose.out
echo "OK compose config"
echo

echo "===== BUILD AND START GATEWAY ====="
"${COMPOSE[@]}" up -d n8n-gpt-gateway

echo

echo "===== STATUS ====="
"${COMPOSE[@]}" ps n8n-gpt-gateway

echo

echo "===== LOCAL HEALTH ====="
curl -s http://127.0.0.1:${GPT_GATEWAY_PORT:-8787}/health || true
echo

echo "===== NEXT STEPS ====="
echo "1) In n8n UI, create an API key."
echo "2) Put it in infra/.env as N8N_API_KEY=..."
echo "3) Restart gateway: docker compose -f infra/docker-compose.yml -f infra/docker-compose.gpt-gateway.yml --env-file infra/.env up -d n8n-gpt-gateway"
echo "4) Expose only the gateway via HTTPS before using Custom GPT Actions."
echo "5) Paste gpt-actions/n8n-control-gateway.openapi.yaml into the GPT Action schema."
