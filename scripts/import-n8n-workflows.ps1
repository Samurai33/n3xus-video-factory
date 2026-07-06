$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

Write-Host "===== N3XUS VIDEO FACTORY — IMPORT N8N WORKFLOWS POWERSHELL ====="
Write-Host "ROOT=$Root"
Write-Host ""

Write-Host "===== CHECK LOCAL FILES ====="
$workflowPath = Join-Path $Root "workflows/importable"
if (!(Test-Path $workflowPath)) {
    throw "Missing workflows/importable"
}
Get-ChildItem -Path $workflowPath -Filter "*.json" | Sort-Object Name | ForEach-Object { Write-Host $_.FullName }
Write-Host ""

Write-Host "===== CHECK N8N CONTAINER ====="
$containers = docker ps --format "{{.Names}}"
if ($containers -notcontains "nvf-n8n") {
    throw "nvf-n8n container is not running. Start stack first: powershell -ExecutionPolicy Bypass -File scripts/bootstrap-n8n-video-factory.ps1"
}
Write-Host "OK nvf-n8n is running"
Write-Host ""

Write-Host "===== IMPORT WORKFLOWS ====="
Write-Host "Importing from container path: /workflows/importable"
Write-Host "n8n import keeps workflows inactive by default unless activeState=fromJson is used."

docker exec nvf-n8n n8n import:workflow --separate --input=/workflows/importable

Write-Host ""
Write-Host "===== IMPORT COMPLETE ====="
Write-Host "Open n8n and review workflows before activating anything."
Write-Host "Local URL: http://127.0.0.1:5678"
Write-Host ""
Write-Host "Expected workflows:"
Write-Host "- NVF 01 - GPT Video Request Intake"
Write-Host "- NVF 02 - Human Review Gate"
Write-Host "- NVF 03 - Publish Assist Package"
