#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

COMPOSE=(docker compose -f infra/docker-compose.yml --env-file infra/.env)

rand_hex() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex "$1"
  else
    date +%s%N | sha256sum | awk '{print $1}'
  fi
}

echo "===== N3XUS VIDEO FACTORY — N8N BOOTSTRAP ====="
echo "ROOT=$ROOT_DIR"
echo

echo "===== CHECK TOOLS ====="
command -v git >/dev/null 2>&1 && git --version || echo "WARN git not found"
command -v docker >/dev/null 2>&1 && docker --version || { echo "ERROR docker not found"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "ERROR docker compose plugin not found"; exit 1; }
docker compose version

echo

echo "===== PREPARE .env ====="
if [ ! -f infra/.env ]; then
  cat > infra/.env <<EOF
POSTGRES_DB=n3xus_video_factory
POSTGRES_USER=nvf
POSTGRES_PASSWORD=$(rand_hex 24)

MINIO_ROOT_USER=n3xus
MINIO_ROOT_PASSWORD=$(rand_hex 24)

N8N_IMAGE_TAG=latest
N8N_ENCRYPTION_KEY=$(rand_hex 32)
N8N_HOST=localhost
N8N_PROTOCOL=http
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
N8N_RUNNERS_ENABLED=true
N8N_DEFAULT_BINARY_DATA_MODE=filesystem
N8N_BINARY_DATA_STORAGE_PATH=/home/node/.n8n/binaryData

GENERIC_TIMEZONE=America/Sao_Paulo
TZ=America/Sao_Paulo
EOF
  chmod 600 infra/.env || true
  echo "OK created infra/.env with generated local secrets"
else
  echo "OK infra/.env already exists; not overwriting"
fi

echo

echo "===== CREATE LOCAL DIRECTORIES ====="
mkdir -p media/{raw,scripts,renders,approved,archive} prompts/{hooks,scripts,captions,ctas} workflows backups

echo

echo "===== VALIDATE COMPOSE ====="
"${COMPOSE[@]}" config >/tmp/nvf-compose-config.out
echo "OK compose config"

echo

echo "===== START STACK ====="
"${COMPOSE[@]}" up -d

echo

echo "===== STATUS ====="
"${COMPOSE[@]}" ps

echo

echo "===== HEALTHCHECK ====="
bash scripts/healthcheck.sh

echo

echo "===== ACCESS ====="
echo "n8n:          http://127.0.0.1:5678"
echo "MinIO API:    http://127.0.0.1:9000"
echo "MinIO Console:http://127.0.0.1:9001"
echo

echo "DONE"
