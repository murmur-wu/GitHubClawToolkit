# Build venv (first run only), install deps, then run bot with auto-restart.
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

if (-not (Test-Path .\.venv)) {
    Write-Host "Creating venv at .\.venv ..." -ForegroundColor Cyan
    py -3 -m venv .venv
}

$python = ".\.venv\Scripts\python.exe"

Write-Host "Installing dependencies..." -ForegroundColor Cyan
& $python -m pip install --upgrade pip --quiet
& $python -m pip install -r requirements.txt --quiet

if (-not (Test-Path .\.env)) {
    Write-Warning ".env not found. Copy .env.example to .env and fill it in first."
    exit 1
}

while ($true) {
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] starting bot..." -ForegroundColor Green
    & $python bot.py
    $code = $LASTEXITCODE
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] bot exited with code $code; restarting in 5s (Ctrl+C to stop)" -ForegroundColor Yellow
    Start-Sleep -Seconds 5
}
