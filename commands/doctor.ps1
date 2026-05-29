# yaaw doctor — Diagnose setup issues
$kgHome = Split-Path $PSScriptRoot -Parent
$repoRoot = Get-Location
$docsFolder = [Environment]::GetFolderPath('MyDocuments')
$issues = 0

Write-Host "YAAW Doctor" -ForegroundColor Cyan
Write-Host ""

# 1. Check git credential.useHttpPath
$credSetting = git config --global credential.useHttpPath
if ($credSetting -eq "true") {
    Write-Host "  [OK] credential.useHttpPath = true" -ForegroundColor Green
} else {
    Write-Host "  [X]  credential.useHttpPath not set" -ForegroundColor Red
    Write-Host "       Fix: git config --global credential.useHttpPath true" -ForegroundColor Yellow
    $issues++
}

# 2. Check PowerShell profiles
$profilePaths = @(
    Join-Path $docsFolder "PowerShell\profile.ps1"
    Join-Path $docsFolder "WindowsPowerShell\profile.ps1"
)
foreach ($p in $profilePaths) {
    if (Test-Path $p) {
        $content = Get-Content $p -Raw -ErrorAction SilentlyContinue
        if ($content -match 'yaaw-cli\.ps1') {
            Write-Host "  [OK] YAAW registered in: $p" -ForegroundColor Green
        } else {
            Write-Host "  [X]  YAAW NOT registered in: $p" -ForegroundColor Red
            Write-Host "       Fix: yaaw reset" -ForegroundColor Yellow
            $issues++
        }
    } else {
        Write-Host "  [X]  Profile missing: $p" -ForegroundColor Red
        Write-Host "       Fix: yaaw reset" -ForegroundColor Yellow
        $issues++
    }
}

# 3. Check router in current repo
$routerPath = Join-Path $repoRoot ".amazonq\rules\yaaw-agent.md"
if (Test-Path (Join-Path $repoRoot "context")) {
    if (Test-Path $routerPath) {
        Write-Host "  [OK] Router exists: .amazonq\rules\yaaw-agent.md" -ForegroundColor Green
    } else {
        Write-Host "  [X]  Router missing in this repo" -ForegroundColor Red
        Write-Host "       Fix: yaaw init" -ForegroundColor Yellow
        $issues++
    }
} else {
    Write-Host "  [--] Not an YAAW repo (no context/ folder)" -ForegroundColor Yellow
}

# 4. Check shared_resources_path
$configFile = Join-Path $repoRoot "context\config.yaml"
if (Test-Path $configFile) {
    $configContent = Get-Content $configFile -Raw -ErrorAction SilentlyContinue
    if ($configContent -match 'shared_resources_path:\s*"(.+)"') {
        $sharedPath = $Matches[1]
        if (Test-Path $sharedPath) {
            Write-Host "  [OK] shared_resources_path: $sharedPath" -ForegroundColor Green
        } else {
            Write-Host "  [X]  shared_resources_path path not found: $sharedPath" -ForegroundColor Red
            Write-Host "       Fix: Update context\config.yaml with correct path" -ForegroundColor Yellow
            $issues++
        }
    } else {
        Write-Host "  [X]  shared_resources_path not set in context\config.yaml" -ForegroundColor Red
        Write-Host "       Fix: yaaw init (or edit context\config.yaml)" -ForegroundColor Yellow
        $issues++
    }
}

# 5. Check dist folder
$distDir = Join-Path $kgHome "dist"
if (Test-Path $distDir) {
    Write-Host "  [OK] dist/ folder present" -ForegroundColor Green
} else {
    Write-Host "  [X]  dist/ folder missing" -ForegroundColor Red
    Write-Host "       Fix: yaaw update" -ForegroundColor Yellow
    $issues++
}

# Summary
Write-Host ""
if ($issues -eq 0) {
    Write-Host "All checks passed." -ForegroundColor Green
} else {
    Write-Host "$issues issue(s) found. See fixes above." -ForegroundColor Red
}
