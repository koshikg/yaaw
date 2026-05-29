# yaaw init - Setup current repo for agentic dev
$yaawHome = Split-Path $PSScriptRoot -Parent
$repoRoot = Get-Location

Write-Host ""
Write-Host "Which AI agent are you using?" -ForegroundColor Cyan
Write-Host "  [1] Amazon Q"
Write-Host "  [2] GitHub Copilot"
Write-Host "  [3] Both"
$agentChoice = Read-Host "  Choice (1/2/3)"

$distDir = Join-Path $yaawHome "dist"
$template = Get-Content "$distDir\templates\yaaw-agent.md" -Raw
$rendered = $template -replace '\{\{YAAW_HOME\}\}', $distDir

if ($agentChoice -eq "1" -or $agentChoice -eq "3") {
    $rulesDir = Join-Path $repoRoot ".amazonq\rules"
    if (-not (Test-Path $rulesDir)) { New-Item -ItemType Directory -Path $rulesDir -Force | Out-Null }
    Set-Content -Path "$rulesDir\yaaw-agent.md" -Value $rendered -NoNewline
    Write-Host "[OK] Amazon Q router: .amazonq\rules\yaaw-agent.md" -ForegroundColor Green
}

if ($agentChoice -eq "2" -or $agentChoice -eq "3") {
    $copilotDir = Join-Path $repoRoot ".github\agents"
    if (-not (Test-Path $copilotDir)) { New-Item -ItemType Directory -Path $copilotDir -Force | Out-Null }
    Set-Content -Path "$copilotDir\yaaw.agent.md" -Value $rendered -NoNewline
    Write-Host "[OK] Copilot agent: .github\agents\yaaw.agent.md" -ForegroundColor Green

    $vscodeDir = Join-Path $repoRoot ".vscode"
    if (-not (Test-Path $vscodeDir)) { New-Item -ItemType Directory -Path $vscodeDir -Force | Out-Null }
    $settingsPath = Join-Path $vscodeDir "settings.json"
    $settings = @{}
    if (Test-Path $settingsPath) { $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json -AsHashtable }
    $settings["github.copilot.chat.defaultAgent"] = "yaaw"
    $settings | ConvertTo-Json | Set-Content $settingsPath -NoNewline
    Write-Host "[OK] Default agent configured in .vscode/settings.json" -ForegroundColor Green
}

$contextDir = Join-Path $repoRoot "context"
if (-not (Test-Path $contextDir)) {
    $dirs = @(
        "context\discovery",
        "context\learnings\packages",
        "context\learnings\deploy",
        "context\learnings\process",
        "context\learnings\general",
        "context\plans",
        "context\work"
    )
    foreach ($dir in $dirs) {
        $path = Join-Path $repoRoot $dir
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        New-Item -ItemType File -Path (Join-Path $path ".gitkeep") -Force | Out-Null
    }

    Copy-Item "$distDir\templates\config.yaml" (Join-Path $contextDir "config.yaml")
    Copy-Item "$distDir\templates\_session.md" (Join-Path $contextDir "_session.md")
    Copy-Item "$distDir\templates\_index.yaml" (Join-Path $contextDir "learnings\_index.yaml")
    Remove-Item (Join-Path $contextDir "learnings\.gitkeep") -ErrorAction SilentlyContinue
    Write-Host "[OK] context/ scaffolded." -ForegroundColor Green
} else {
    Write-Host "[--] context/ already exists, skipping scaffold." -ForegroundColor Yellow
}

$gitignore = Join-Path $repoRoot ".gitignore"
$ignoreEntries = @()
if ($agentChoice -eq "1" -or $agentChoice -eq "3") { $ignoreEntries += ".amazonq/rules/yaaw-agent.md" }
if ($agentChoice -eq "2" -or $agentChoice -eq "3") { $ignoreEntries += ".github/agents/yaaw.agent.md" }

if (Test-Path $gitignore) {
    $content = Get-Content $gitignore -Raw
    $missing = $ignoreEntries | Where-Object { $content -notmatch [regex]::Escape($_) }
    if ($missing) {
        $block = "`n# YAAW agent routers (generated per-dev)`n" + ($missing -join "`n")
        Add-Content -Path $gitignore -Value $block
        Write-Host "[OK] .gitignore updated." -ForegroundColor Green
    }
} else {
    $block = "# YAAW agent routers (generated per-dev)`n" + ($ignoreEntries -join "`n")
    Set-Content -Path $gitignore -Value $block
    Write-Host "[OK] .gitignore created." -ForegroundColor Green
}

$configFile = Join-Path $contextDir "config.yaml"
$configContent = Get-Content $configFile -Raw -ErrorAction SilentlyContinue
if ($configContent -and $configContent -match 'yaaw_workspace_root:') {
    Write-Host "[--] yaaw_workspace_root already set in context\config.yaml" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Where is your workspace root?" -ForegroundColor Cyan
    Write-Host "  The agent can use this parent folder to find sibling repos when cross-repo context is needed." -ForegroundColor Gray
    $workspaceRoot = Read-Host "  Path (optional)"
    if ($workspaceRoot -and (Test-Path $workspaceRoot)) {
        Add-Content -Path $configFile -Value "`nyaaw_workspace_root: `"$workspaceRoot`""
        Write-Host "[OK] yaaw_workspace_root saved to context\config.yaml" -ForegroundColor Green
    } elseif ($workspaceRoot) {
        Write-Host "[!] Path not found. Add yaaw_workspace_root manually to context\config.yaml" -ForegroundColor Yellow
    } else {
        Write-Host "[!] Skipped. Add yaaw_workspace_root to context\config.yaml when ready." -ForegroundColor Yellow
    }
}

Write-Host "`nRepo ready for YAAW." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Reload VS Code window" -ForegroundColor Gray
Write-Host "  2. Open your AI chat" -ForegroundColor Gray
Write-Host "  3. Use yaaw skills to discover the available workflow skills" -ForegroundColor Gray
Write-Host ""