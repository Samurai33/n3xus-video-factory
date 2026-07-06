#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

COMPOSE=(docker compose -f infra/docker-compose.yml --env-file infra/.env)

echo "===== N3XUS VIDEO FACTORY HEALTHCHECK ====="
echo "ROOT=$ROOT_DIR"
echo

echo "===== GIT ====="
git branch --show-current || true
git status --short || true
echo

echo "===== FILES ====="
test -f infra/docker-compose.yml && echo "OK infra/docker-compose.yml" || echo "MISSING infra/docker-compose.yml"
test -f infra/.env && echo "OK infra/.env" || echo "MISSING infra/.env"
echo

echo "===== SYSTEM ====="
hostnamectl 2>/dev/null || hostname || true
uptime || true
free -h || true
df -h || true
echo

echo "===== DOCKER ====="
docker --version || true
docker compose version || true
docker ps -a || true
echo

echo "===== PORTS ====="
ss -lntup 2>/dev/null || netstat -ano 2>/dev/null || true
echo

if [ -f infra/.env ]; then
  echo "===== COMPOSE CONFIG ====="
  "${COMPOSE[@]}" config >/tmp/nvf-compose-config.out
  echo "OK compose config"
  echo

  echo "===== COMPOSE PS ====="
  "${COMPOSE[@]}" ps || true
else
  echo "SKIP compose checks: infra/.env not found"
fi

echo
echo "===== DONE ====="
