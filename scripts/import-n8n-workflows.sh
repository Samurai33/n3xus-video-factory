#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

WORKFLOW_DIR="/workflows/importable"
LOCAL_WORKFLOW_DIR="$ROOT_DIR/workflows/importable"
COMPOSE=(docker compose -f infra/docker-compose.yml --env-file infra/.env)

echo "===== N3XUS VIDEO FACTORY — IMPORT N8N WORKFLOWS ====="
echo "ROOT=$ROOT_DIR"
echo

echo "===== CHECK LOCAL FILES ====="
test -d "$LOCAL_WORKFLOW_DIR" || { echo "ERROR missing $LOCAL_WORKFLOW_DIR"; exit 1; }
find "$LOCAL_WORKFLOW_DIR" -maxdepth 1 -name '*.json' -type f -print | sort

echo

echo "===== CHECK N8N CONTAINER ====="
if ! docker ps --format '{{.Names}}' | grep -qx 'nvf-n8n'; then
  echo "ERROR nvf-n8n container is not running. Start stack first: make bootstrap-n8n"
  exit 1
fi

echo "OK nvf-n8n is running"

echo

echo "===== IMPORT WORKFLOWS ====="
echo "Importing from container path: $WORKFLOW_DIR"
echo "n8n import keeps workflows inactive by default unless activeState=fromJson is used."

docker exec nvf-n8n n8n import:workflow --separate --input="$WORKFLOW_DIR"

echo

echo "===== IMPORT COMPLETE ====="
echo "Open n8n and review workflows before activating anything."
echo "Local URL: http://127.0.0.1:5678"
echo

echo "Expected workflows:"
echo "- NVF 01 - GPT Video Request Intake"
echo "- NVF 02 - Human Review Gate"
echo "- NVF 03 - Publish Assist Package"
