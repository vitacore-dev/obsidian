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

function Get-DefaultBranchName {
    param([string]$RepoDir)

    Push-Location $RepoDir
    try {
        $headSymref = git ls-remote --symref origin HEAD 2>$null | Select-String 'ref: refs/heads/' | Select-Object -First 1
        if ($headSymref) {
            $line = $headSymref.ToString()
            if ($line -match 'ref:\s+refs/heads/([^\s]+)\s+HEAD') {
                return $Matches[1]
            }
        }

        git remote show origin 2>$null | ForEach-Object {
            if ($_ -match '^\s*HEAD branch:\s*(.+)\s*$') {
                return $Matches[1].Trim()
            }
        }

        $sym = (git symbolic-ref -q --short refs/remotes/origin/HEAD 2>$null).Trim()
        if ($sym) {
            if ($sym -match '^origin/(.+)$') {
                return $Matches[1]
            }
            return $sym
        }

        $remoteMain = git show-ref --verify --quiet refs/remotes/origin/main; if ($LASTEXITCODE -eq 0) { return "main" }
        $remoteMaster = git show-ref --verify --quiet refs/remotes/origin/master; if ($LASTEXITCODE -eq 0) { return "master" }

        $anyRemote = git for-each-ref --format='%(refname:short)' refs/remotes/origin | Select-Object -First 1
        if ($anyRemote -and $anyRemote -match '^origin/(.+)$') {
            return $Matches[1]
        }
    }
    finally {
        Pop-Location
    }
    return ""
}

function Test-WorkingTreeHasFiles {
    param([string]$RepoDir)

    $items = Get-ChildItem -LiteralPath $RepoDir -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ne ".git" }
    return ($null -ne $items -and $items.Count -gt 0)
}

function Repair-EmptyWorkingTree {
    param([string]$RepoDir)

    if (Test-WorkingTreeHasFiles -RepoDir $RepoDir) {
        return
    }

    Write-Warn "Repository folder exists but working tree has no files (only .git or empty). Trying fetch + checkout."
    Push-Location $RepoDir
    try {
        git fetch origin
        $branch = Get-DefaultBranchName -RepoDir $RepoDir
        if ([string]::IsNullOrWhiteSpace($branch)) {
            throw "Could not detect default remote branch after fetch. Check repository access and authentication."
        }

        $remoteBranchRef = "refs/remotes/origin/$branch"
        git show-ref --verify --quiet $remoteBranchRef
        if ($LASTEXITCODE -ne 0) {
            throw "Remote branch 'origin/$branch' is not available locally after fetch. Check permissions and remote repository state."
        }

        git checkout -B $branch "origin/$branch"
        if (-not (Test-WorkingTreeHasFiles -RepoDir $RepoDir)) {
            git reset --hard "origin/$branch"
        }
    }
    finally {
        Pop-Location
    }

    if (-not (Test-WorkingTreeHasFiles -RepoDir $RepoDir)) {
        throw "Working tree is still empty after repair. Delete folder '$RepoDir' and run the script again, or clone manually: git clone $RepoUrl"
    }
    Write-Host "Working tree restored."
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

Repair-EmptyWorkingTree -RepoDir $RepoPath

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

    $top = Get-ChildItem -LiteralPath (Get-Location) -Force |
        Where-Object { $_.Name -ne ".git" } |
        Select-Object -First 15 Name
    if ($top) {
        Write-Host "Top-level items (first 15):"
        $top | ForEach-Object { Write-Host "  $($_.Name)" }
    }
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
Write-Host "Tip: In Windows Explorer, enable Hidden items if the folder looks empty (.git is hidden by default)."
