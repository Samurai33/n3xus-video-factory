#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

COMPOSE=(docker compose -f infra/docker-compose.yml --env-file infra/.env)
COMPOSE_GATEWAY=(docker compose -f infra/docker-compose.yml -f infra/docker-compose.gpt-gateway.yml --env-file infra/.env)

echo "===== N3XUS VIDEO FACTORY — N8N CONNECTION CHECK ====="
echo "ROOT=$ROOT_DIR"
echo

echo "===== LOCAL FILES ====="
test -f infra/docker-compose.yml && echo "OK infra/docker-compose.yml" || echo "MISSING infra/docker-compose.yml"
test -f infra/.env && echo "OK infra/.env" || echo "MISSING infra/.env"
echo

echo "===== DOCKER CONTAINERS ====="
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | grep -E 'nvf-|NAMES' || true
echo

echo "===== N8N LOCAL HTTP ====="
if curl -fsS http://127.0.0.1:5678 >/tmp/nvf-n8n-root.html 2>/dev/null; then
  echo "OK n8n responded on http://127.0.0.1:5678"
else
  echo "WARN n8n did not respond on http://127.0.0.1:5678 from this host"
fi
echo

echo "===== GATEWAY LOCAL HEALTH ====="
if curl -fsS http://127.0.0.1:8787/health >/tmp/nvf-gateway-health.json 2>/dev/null; then
  echo "OK gateway responded on http://127.0.0.1:8787/health"
  cat /tmp/nvf-gateway-health.json
  echo
else
  echo "WARN gateway did not respond on http://127.0.0.1:8787/health"
fi
echo

echo "===== COMPOSE STATUS ====="
if [ -f infra/.env ]; then
  "${COMPOSE[@]}" ps || true
  echo
  "${COMPOSE_GATEWAY[@]}" ps n8n-gpt-gateway || true
else
  echo "SKIP compose status: infra/.env missing"
fi

echo

echo "===== RESULT ====="
echo "If n8n or gateway are WARN, run:"
echo "  make bootstrap-n8n"
echo "  make bootstrap-gpt-gateway"
echo "  make import-n8n-workflows"
