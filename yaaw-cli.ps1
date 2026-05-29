# YAAW CLI - Command Router
param([string]$Command = "help")

$yaawHome = $PSScriptRoot

function Write-YAAWCommand {
    param(
        [string]$Name,
        [string]$Description,
        [ConsoleColor]$Color = [ConsoleColor]::Gray
    )

    Write-Host "    " -NoNewline
    Write-Host $Name.PadRight(13) -NoNewline -ForegroundColor $Color
    Write-Host $Description
}

function Show-YAAWHelp {
    $repoRoot = Get-Location
    $hasContext = Test-Path (Join-Path $repoRoot "context")

    Write-Host ""
    Write-Host "  YAAW" -ForegroundColor Cyan
    Write-Host "  yet another agentic workflow" -ForegroundColor DarkGray
    Write-Host "  ----------------------------------------" -ForegroundColor DarkGray
    Write-Host ""

    Write-Host "  Next step" -ForegroundColor White
    if ($hasContext) {
        Write-YAAWCommand "yaaw status" "Check this repo's agent setup" Green
        Write-Host "    This repo already has context/." -ForegroundColor DarkGray
    } else {
        Write-YAAWCommand "yaaw init" "Set up this repo for human+AI collaboration" Green
        Write-Host "    Run this from the repository you want to onboard." -ForegroundColor DarkGray
    }

    Write-Host ""
    Write-Host "  Commands" -ForegroundColor White
    Write-YAAWCommand "yaaw init" "Setup current repo for agentic dev"
    Write-YAAWCommand "yaaw update" "Pull latest skills + refresh router"
    Write-YAAWCommand "yaaw skills" "List skills + open directory"
    Write-YAAWCommand "yaaw status" "Show version and setup info"
    Write-YAAWCommand "yaaw doctor" "Diagnose setup issues"
    Write-YAAWCommand "yaaw reset" "Repair install + regenerate router"
    Write-YAAWCommand "yaaw help" "Show this help message"

    Write-Host ""
    Write-Host "  Already installed?" -ForegroundColor White
    Write-Host "    Run " -NoNewline
    Write-Host "yaaw update" -NoNewline -ForegroundColor Yellow
    Write-Host " for the latest skills, or " -NoNewline
    Write-Host "yaaw reset" -NoNewline -ForegroundColor Yellow
    Write-Host " to repair setup."
    Write-Host ""
}

switch ($Command) {
    "init"   { & "$yaawHome\commands\init.ps1" }
    "update" { & "$yaawHome\commands\update.ps1" }
    "skills" { & "$yaawHome\commands\skills.ps1" }
    "status" { & "$yaawHome\commands\status.ps1" }
    "doctor" { & "$yaawHome\commands\doctor.ps1" }
    "reset"  { & "$yaawHome\commands\reset.ps1" }
    "help"   { Show-YAAWHelp }
    default  {
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Write-Host "Run 'yaaw help' for available commands." -ForegroundColor Yellow
    }
}