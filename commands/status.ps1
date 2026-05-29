# yaaw status — Show version and setup info
$kgHome = Split-Path $PSScriptRoot -Parent
$repoRoot = Get-Location

$version = Get-Content "$kgHome\version.json" | ConvertFrom-Json
$lastCommit = git -C $kgHome log --oneline -1

Write-Host ""
Write-Host "  YAAW" -ForegroundColor Cyan
Write-Host "  ───────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Skills home :  $kgHome"
Write-Host "  Version     :  v$($version.version) ($($version.date))"
Write-Host "  Last commit :  $lastCommit"
Write-Host ""

# Check if update is available (by comparing version numbers, not commits)
git -C $kgHome fetch --quiet 2>$null
$remoteVersion = git -C $kgHome show origin/main:version.json 2>$null | ConvertFrom-Json
$localVersion = $version.version

if ($remoteVersion -and $remoteVersion.version -ne $localVersion) {
    Write-Host "  UPDATE AVAILABLE  v$($remoteVersion.version) is ready" -ForegroundColor Yellow
    Write-Host "  Run: yaaw update" -ForegroundColor Yellow
    Write-Host ""
    
    $response = Read-Host "  Update now? (y/n)" 
    if ($response -eq 'y' -or $response -eq 'yes') {
        Write-Host ""
        & "$PSScriptRoot\update.ps1"
    } else {
        Write-Host "  Skipped. Run 'yaaw update' when ready." -ForegroundColor Gray
        Write-Host ""
    }
} else {
    Write-Host "  ✓ Up to date" -ForegroundColor Green
    Write-Host ""
}

# Current repo info
Write-Host "  Repo" -ForegroundColor Cyan
Write-Host "  ───────────────────────────────────────" -ForegroundColor DarkGray
if (Test-Path (Join-Path $repoRoot "context")) {
    $routerExists = Test-Path (Join-Path $repoRoot ".amazonq\rules\yaaw-agent.md")
    $copilotAgentExists = Test-Path (Join-Path $repoRoot ".github\agents\yaaw.agent.md")
    $settingsPath = Join-Path $repoRoot ".vscode\settings.json"
    $copilotDefault = $false
    if (Test-Path $settingsPath) {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
        $copilotDefault = $settings."github.copilot.chat.defaultAgent" -eq "YAAW"
    }
    
    Write-Host "  Path   :  $repoRoot"
    if ($routerExists) {
        Write-Host "  Q      :  " -NoNewline
        Write-Host "✓ Generated" -ForegroundColor Green
    } else {
        Write-Host "  Q      :  " -NoNewline
        Write-Host "✗ Missing" -ForegroundColor Red
    }
    
    if ($copilotAgentExists -and $copilotDefault) {
        Write-Host "  Copilot:  " -NoNewline
        Write-Host "✓ Active (default)" -ForegroundColor Green
    } elseif ($copilotAgentExists) {
        Write-Host "  Copilot:  " -NoNewline
        Write-Host "⚠ Installed (not default)" -ForegroundColor Yellow
    } else {
        Write-Host "  Copilot:  " -NoNewline
        Write-Host "✗ Not set up" -ForegroundColor Red -NoNewline
        Write-Host " — run: yaaw init"
    }
} else {
    Write-Host "  Not an YAAW repo (no context/ folder)." -ForegroundColor Yellow
    Write-Host "  Run 'yaaw init' to set it up." -ForegroundColor Yellow
}
Write-Host ""
