# yaaw reset — Repair install, pull latest, and regenerate router
$kgHome = Split-Path $PSScriptRoot -Parent

Write-Host "YAAW Reset" -ForegroundColor Cyan
Write-Host "Non-destructive: does not delete ~/.yaaw or repo context/." -ForegroundColor Yellow
Write-Host ""

# 1. Re-run install (registers profiles)
Write-Host "--- Re-running install ---" -ForegroundColor White
& "$kgHome\install.ps1"
Write-Host ""

# 2. Pull latest (update)
Write-Host "--- Pulling latest skills ---" -ForegroundColor White
& "$kgHome\commands\update.ps1"
Write-Host ""

# 3. Re-init current repo
$repoRoot = Get-Location
if (Test-Path (Join-Path $repoRoot "context")) {
    Write-Host "--- Re-initializing repo ---" -ForegroundColor White
    & "$kgHome\commands\init.ps1"
} else {
    Write-Host "[--] Not in an YAAW repo, skipping init." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Reset complete. Restart your terminal." -ForegroundColor Green
