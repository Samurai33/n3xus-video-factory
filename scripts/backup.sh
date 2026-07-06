#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${BACKUP_DIR:-$ROOT_DIR/backups/$STAMP}"
COMPOSE=(docker compose -f infra/docker-compose.yml --env-file infra/.env)

mkdir -p "$BACKUP_DIR"

echo "===== N3XUS VIDEO FACTORY BACKUP ====="
echo "BACKUP_DIR=$BACKUP_DIR"
echo

echo "===== BACKUP DOCS / WORKFLOWS / PROMPTS ====="
tar -czf "$BACKUP_DIR/project-config-$STAMP.tar.gz" \
  CLAUDE.md AGENTS.md README.md docs infra workflows prompts .claude scripts Makefile Taskfile.yml 2>/dev/null || true

echo "OK project config archive"

if [ -d media/approved ] || [ -d media/scripts ]; then
  echo "===== BACKUP MEDIA METADATA ====="
  tar -czf "$BACKUP_DIR/media-curated-$STAMP.tar.gz" media/approved media/scripts 2>/dev/null || true
  echo "OK media curated archive"
fi

if [ -f infra/.env ]; then
  echo "===== DOCKER VOLUME LIST ====="
  docker volume ls > "$BACKUP_DIR/docker-volumes-$STAMP.txt" || true

  echo "===== COMPOSE PS ====="
  "${COMPOSE[@]}" ps > "$BACKUP_DIR/compose-ps-$STAMP.txt" || true
else
  echo "SKIP compose metadata: infra/.env not found"
fi

echo
echo "Backup created at: $BACKUP_DIR"
echo "IMPORTANT: infra/.env is not copied by default. Store secrets separately."
