# YAAW Skills - First-Time Install
# Run once after cloning: & $env:USERPROFILE\.yaaw\install.ps1

$yaawHome = $PSScriptRoot

# Register in both PowerShell 7 (pwsh) and Windows PowerShell 5.1 AllHosts profiles
$docsFolder = [Environment]::GetFolderPath('MyDocuments')
$profilePaths = @(
    Join-Path $docsFolder "PowerShell\profile.ps1"
    Join-Path $docsFolder "WindowsPowerShell\profile.ps1"
)

$functionBlock = @"

# YAAW CLI
function yaaw { & "$yaawHome\yaaw-cli.ps1" @args }
"@

foreach ($profilePath in $profilePaths) {
    $dir = Split-Path $profilePath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    if (-not (Test-Path $profilePath)) { New-Item -ItemType File -Path $profilePath -Force | Out-Null }

    $content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content -or $content -notmatch 'yaaw-cli\.ps1') {
        Add-Content -Path $profilePath -Value $functionBlock
        Write-Host "[OK] 'YAAW' registered in: $profilePath" -ForegroundColor Green
    } else {
        Write-Host "[OK] 'YAAW' already registered in: $profilePath" -ForegroundColor Green
    }
}

Write-Host "     Restart your terminals for changes to take effect." -ForegroundColor Yellow

Write-Host ""
Write-Host "YAAW installed." -ForegroundColor Cyan
& "$yaawHome\yaaw-cli.ps1" help
