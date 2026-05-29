# yaaw skills - Display installed yaaw skills dynamically
$yaawHome = Split-Path $PSScriptRoot -Parent
$skillsDir = Join-Path $yaawHome "dist\skills"
$skillsDirectoryUrl = Join-Path $yaawHome "showcase\browse.html"

function Get-YAAWSkillMetadata {
    param([string]$SkillPath)

    $content = Get-Content $SkillPath -Raw -ErrorAction Stop
    $frontmatterMatch = [regex]::Match($content, '(?s)^---\s*\r?\n(.*?)\r?\n---')
    $metadata = @{}
    $activeMultilineKey = $null

    if ($frontmatterMatch.Success) {
        foreach ($rawLine in ($frontmatterMatch.Groups[1].Value -split "\r?\n")) {
            if ([string]::IsNullOrWhiteSpace($rawLine)) {
                continue
            }

            if ($activeMultilineKey -and $rawLine -match '^\s+') {
                $metadata[$activeMultilineKey] = ($metadata[$activeMultilineKey] + ' ' + $rawLine.Trim()).Trim()
                continue
            }

            $activeMultilineKey = $null
            $keyValue = [regex]::Match($rawLine, '^\s*([A-Za-z0-9_-]+):\s*(.*)\s*$')
            if ($keyValue.Success) {
                $key = $keyValue.Groups[1].Value
                $value = $keyValue.Groups[2].Value.Trim()
                if ($value -eq '>') {
                    $metadata[$key] = ''
                    $activeMultilineKey = $key
                    continue
                }

                $value = $value -replace '^"|"$', ''
                $metadata[$key] = $value
            }
        }
    }

    $folderName = Split-Path (Split-Path $SkillPath -Parent) -Leaf
    $name = if ($metadata.ContainsKey('name') -and $metadata['name']) { $metadata['name'] } else { $folderName }

    [PSCustomObject]@{
        Name = $name
        Command = "/$name"
    }
}

Write-Host ""
Write-Host "  YAAW Skills" -ForegroundColor Cyan
Write-Host "  ----------------------------------------" -ForegroundColor DarkGray

if (-not (Test-Path $skillsDir)) {
    Write-Host "  No skills directory found: $skillsDir" -ForegroundColor Red
    Write-Host "  Run 'yaaw update' to refresh the local skills checkout." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

$skills = Get-ChildItem -Path $skillsDir -Directory |
    ForEach-Object {
        $skillPath = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $skillPath) {
            Get-YAAWSkillMetadata -SkillPath $skillPath
        }
    } |
    Sort-Object Name

if (-not $skills) {
    Write-Host "  No skills found in: $skillsDir" -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

Write-Host "  Found: $($skills.Count) skill(s)"
Write-Host ""

foreach ($skill in $skills) {
    Write-Host "  $($skill.Command)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Full directory: $skillsDirectoryUrl" -ForegroundColor DarkGray
if ([Console]::IsInputRedirected) {
    Write-Host "  Open YAAW skills directory? (y/N): " -NoNewline
    $openDirectory = [Console]::In.ReadLine()
    Write-Host $openDirectory
} else {
    $openDirectory = Read-Host "  Open YAAW skills directory? (y/N)"
}

if ($openDirectory -eq 'y' -or $openDirectory -eq 'yes') {
    Start-Process $skillsDirectoryUrl
    Write-Host "  Opening skills directory..." -ForegroundColor Green
}
Write-Host ""
