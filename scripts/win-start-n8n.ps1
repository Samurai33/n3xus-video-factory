$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

Write-Host "===== N3XUS VIDEO FACTORY - WINDOWS START ====="
Write-Host "ROOT=$Root"
Write-Host ""

docker --version
docker compose version
Write-Host ""

if (!(Test-Path "infra/.env")) {
    Copy-Item "infra/.env.example" "infra/.env"
    Write-Host "OK created infra/.env"
}

$dirs = @("media/raw", "media/scripts", "media/renders", "media/approved", "media/archive", "prompts/hooks", "prompts/scripts", "prompts/captions", "prompts/ctas", "workflows", "backups")
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

Write-Host "===== VALIDATE COMPOSE ====="
docker compose -f infra/docker-compose.yml --env-file infra/.env config | Out-Null
Write-Host "OK compose config"

Write-Host "===== START STACK ====="
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d

Write-Host "===== STATUS ====="
docker compose -f infra/docker-compose.yml --env-file infra/.env ps

Write-Host "===== ACCESS ====="
Write-Host "n8n: http://127.0.0.1:5678"
Write-Host "MinIO: http://127.0.0.1:9001"
