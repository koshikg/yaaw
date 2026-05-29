# yaaw update — Pull latest skills + refresh router
$kgHome = Split-Path $PSScriptRoot -Parent

# Check if update is needed (compare versions)
git -C $kgHome fetch --quiet 2>$null
$localVersion = Get-Content "$kgHome\version.json" | ConvertFrom-Json
$remoteVersion = git -C $kgHome show origin/main:version.json 2>$null | ConvertFrom-Json

if ($remoteVersion -and $remoteVersion.version -ne $localVersion.version) {
    Write-Host "Pulling latest yaaw-skills..." -ForegroundColor Cyan
    git -C $kgHome pull
} else {
    Write-Host "Already on latest version" -ForegroundColor Green
}

# Re-generate routers if we're in a repo
$repoRoot = Get-Location
if (Test-Path (Join-Path $repoRoot "context")) {
    $distDir = Join-Path $kgHome "dist"
    $template = Get-Content "$distDir\templates\yaaw-agent.md" -Raw
    $rendered = $template -replace '\{\{YAAW_HOME\}\}', $distDir

    # Refresh whichever agent files already exist
    $qRouter = Join-Path $repoRoot ".amazonq\rules\yaaw-agent.md"
    $copilotRouter = Join-Path $repoRoot ".github\agents\yaaw.agent.md"
    $settingsPath = Join-Path $repoRoot ".vscode\settings.json"

    if (Test-Path $qRouter) {
        Set-Content -Path $qRouter -Value $rendered -NoNewline
    }
    if (Test-Path $copilotRouter) {
        Set-Content -Path $copilotRouter -Value $rendered -NoNewline
    }
    if (Test-Path $settingsPath) {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json -AsHashtable
        $settings["github.copilot.chat.defaultAgent"] = "YAAW"
        $settings | ConvertTo-Json | Set-Content $settingsPath -NoNewline
    }

    Write-Host "[OK] Router(s) and config refreshed." -ForegroundColor Green
}

# Write last-updated timestamp
$version = Get-Content "$kgHome\version.json" | ConvertFrom-Json
[PSCustomObject]@{ version = $version.version; date = $version.date; updated_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss") } | ConvertTo-Json | Set-Content "$kgHome\.last-update"

Write-Host "[OK] yaaw-skills v$($version.version) ($($version.date))" -ForegroundColor Green
