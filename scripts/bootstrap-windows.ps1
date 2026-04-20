param(
    [string]$RepoUrl = "https://github.com/vitacore-dev/obsidian.git",
    [string]$TargetParent = "$HOME\Documents",
    [string]$RepoName = "obsidian",
    [switch]$SkipPull
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Warn {
    param([string]$Message)
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

function Ensure-Command {
    param(
        [Parameter(Mandatory = $true)][string]$CommandName,
        [Parameter(Mandatory = $true)][string]$InstallHint
    )

    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        throw "Command '$CommandName' not found. $InstallHint"
    }
}

Write-Host "Windows onboarding bootstrap" -ForegroundColor Green
Write-Host "This script checks tools and prepares a local repository."

Write-Step "Checking tools"
Ensure-Command -CommandName "git" -InstallHint "Install Git for Windows: https://git-scm.com/download/win"

Write-Host "Git detected: $(git --version)"

if (Get-Command "gh" -ErrorAction SilentlyContinue) {
    Write-Host "GitHub CLI detected: $(gh --version | Select-Object -First 1)"
} else {
    Write-Warn "GitHub CLI (gh) not found. This is fine, but authentication may be easier with GitHub Desktop."
}

Write-Step "Preparing directories"
if (-not (Test-Path -Path $TargetParent)) {
    Write-Host "Creating directory: $TargetParent"
    New-Item -Path $TargetParent -ItemType Directory | Out-Null
}

$RepoPath = Join-Path $TargetParent $RepoName
Write-Host "Target repository path: $RepoPath"

Write-Step "Cloning or reusing repository"
if (Test-Path -Path $RepoPath) {
    if (-not (Test-Path -Path (Join-Path $RepoPath ".git"))) {
        throw "Directory '$RepoPath' already exists, but it is not a git repository. Rename/delete it and run the script again."
    }

    Write-Host "Found existing git repository."
} else {
    Write-Host "Cloning: $RepoUrl"
    git clone $RepoUrl $RepoPath
}

Write-Step "Checking repository status"
Push-Location $RepoPath
try {
    $remoteUrl = git remote get-url origin
    Write-Host "origin: $remoteUrl"

    $branch = git branch --show-current
    if ([string]::IsNullOrWhiteSpace($branch)) {
        Write-Warn "Could not determine current branch."
    } else {
        Write-Host "Current branch: $branch"
    }

    if (-not $SkipPull) {
        Write-Host "Running git pull --rebase..."
        git pull --rebase
    } else {
        Write-Host "Pull step skipped (-SkipPull)."
    }

    Write-Host "Repository status:"
    git status --short --branch
}
finally {
    Pop-Location
}

Write-Step "Done"
Write-Host "1) Open Obsidian."
Write-Host "2) Choose 'Open folder as vault' and select: $RepoPath"
Write-Host "3) Enable Community plugin 'Obsidian Git'."
Write-Host "4) Run command 'Obsidian Git: Pull'."
Write-Host ""
Write-Host "If auth fails, run 'gh auth login' or sign in via GitHub Desktop." -ForegroundColor Yellow
