$ErrorActionPreference = "Continue"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

Write-Host "===== N3XUS VIDEO FACTORY — N8N CONNECTION CHECK POWERSHELL ====="
Write-Host "ROOT=$Root"
Write-Host ""

Write-Host "===== LOCAL FILES ====="
if (Test-Path "infra/docker-compose.yml") { Write-Host "OK infra/docker-compose.yml" } else { Write-Host "MISSING infra/docker-compose.yml" }
if (Test-Path "infra/.env") { Write-Host "OK infra/.env" } else { Write-Host "MISSING infra/.env" }
Write-Host ""

Write-Host "===== DOCKER ====="
docker --version
docker compose version
Write-Host ""

Write-Host "===== DOCKER CONTAINERS ====="
docker ps --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}"
Write-Host ""

Write-Host "===== N8N LOCAL HTTP ====="
try {
    Invoke-WebRequest -UseBasicParsing -Uri "http://127.0.0.1:5678" -TimeoutSec 5 | Out-Null
    Write-Host "OK n8n responded on http://127.0.0.1:5678"
} catch {
    Write-Host "WARN n8n did not respond on http://127.0.0.1:5678 from this host"
}
Write-Host ""

Write-Host "===== GATEWAY LOCAL HEALTH ====="
try {
    $gateway = Invoke-WebRequest -UseBasicParsing -Uri "http://127.0.0.1:8787/health" -TimeoutSec 5
    Write-Host "OK gateway responded on http://127.0.0.1:8787/health"
    Write-Host $gateway.Content
} catch {
    Write-Host "WARN gateway did not respond on http://127.0.0.1:8787/health"
}
Write-Host ""

Write-Host "===== COMPOSE STATUS ====="
if (Test-Path "infra/.env") {
    docker compose -f infra/docker-compose.yml --env-file infra/.env ps
} else {
    Write-Host "SKIP compose status: infra/.env missing"
}
Write-Host ""

Write-Host "===== RESULT ====="
Write-Host "If n8n is WARN, run:"
Write-Host "  powershell -ExecutionPolicy Bypass -File scripts/bootstrap-n8n-video-factory.ps1"
Write-Host "Then import workflows:"
Write-Host "  powershell -ExecutionPolicy Bypass -File scripts/import-n8n-workflows.ps1"
