$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

function New-RandomHex([int]$Bytes) {
    $buffer = New-Object byte[] $Bytes
    [System.Security.Cryptography.RandomNumberGenerator]::Fill($buffer)
    return ([System.BitConverter]::ToString($buffer) -replace '-', '').ToLower()
}

Write-Host "===== N3XUS VIDEO FACTORY — N8N BOOTSTRAP POWERSHELL ====="
Write-Host "ROOT=$Root"
Write-Host ""

Write-Host "===== CHECK TOOLS ====="
docker --version
docker compose version
Write-Host ""

Write-Host "===== PREPARE .env ====="
$envPath = Join-Path $Root "infra/.env"
if (!(Test-Path $envPath)) {
    $content = @"
POSTGRES_DB=n3xus_video_factory
POSTGRES_USER=nvf
POSTGRES_PASSWORD=$(New-RandomHex 24)

MINIO_ROOT_USER=n3xus
MINIO_ROOT_PASSWORD=$(New-RandomHex 24)

N8N_IMAGE_TAG=latest
N8N_ENCRYPTION_KEY=$(New-RandomHex 32)
N8N_HOST=localhost
N8N_PROTOCOL=http
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
N8N_RUNNERS_ENABLED=true
N8N_DEFAULT_BINARY_DATA_MODE=filesystem
N8N_BINARY_DATA_STORAGE_PATH=/home/node/.n8n/binaryData

GENERIC_TIMEZONE=America/Sao_Paulo
TZ=America/Sao_Paulo

GPT_GATEWAY_PORT=8787
GPT_GATEWAY_API_KEY=$(New-RandomHex 32)
GPT_GATEWAY_REQUIRE_AUTH=true
N8N_BASE_URL=http://n8n:5678
N8N_API_KEY=change-me-n8n-api-key-after-ui-setup
"@
    Set-Content -Path $envPath -Value $content -Encoding UTF8
    Write-Host "OK created infra/.env with generated local secrets"
} else {
    Write-Host "OK infra/.env already exists; not overwriting"
}
Write-Host ""

Write-Host "===== CREATE LOCAL DIRECTORIES ====="
$dirs = @(
    "media/raw",
    "media/scripts",
    "media/renders",
    "media/approved",
    "media/archive",
    "prompts/hooks",
    "prompts/scripts",
    "prompts/captions",
    "prompts/ctas",
    "workflows",
    "backups"
)
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $Root $dir) | Out-Null
}
Write-Host "OK directories"
Write-Host ""

Write-Host "===== VALIDATE COMPOSE ====="
docker compose -f infra/docker-compose.yml --env-file infra/.env config | Out-Null
Write-Host "OK compose config"
Write-Host ""

Write-Host "===== START STACK ====="
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
Write-Host ""

Write-Host "===== STATUS ====="
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
Write-Host ""

Write-Host "===== ACCESS ====="
Write-Host "n8n:           http://127.0.0.1:5678"
Write-Host "MinIO API:     http://127.0.0.1:9000"
Write-Host "MinIO Console: http://127.0.0.1:9001"
Write-Host ""
Write-Host "DONE"
