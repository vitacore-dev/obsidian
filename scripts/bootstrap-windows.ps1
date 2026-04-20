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
        throw "Команда '$CommandName' не найдена. $InstallHint"
    }
}

Write-Host "Windows bootstrap для onboarding базы знаний" -ForegroundColor Green
Write-Host "Этот скрипт проверит окружение и подготовит локальный репозиторий."

Write-Step "Проверка инструментов"
Ensure-Command -CommandName "git" -InstallHint "Установите Git for Windows: https://git-scm.com/download/win"

Write-Host "Git найден: $(git --version)"

if (Get-Command "gh" -ErrorAction SilentlyContinue) {
    Write-Host "GitHub CLI найден: $(gh --version | Select-Object -First 1)"
} else {
    Write-Warn "GitHub CLI (gh) не найден. Это нормально, но авторизацию может быть проще сделать через GitHub Desktop."
}

Write-Step "Подготовка директорий"
if (-not (Test-Path -Path $TargetParent)) {
    Write-Host "Создаю папку: $TargetParent"
    New-Item -Path $TargetParent -ItemType Directory | Out-Null
}

$RepoPath = Join-Path $TargetParent $RepoName
Write-Host "Целевая папка репозитория: $RepoPath"

Write-Step "Клонирование или проверка существующего репозитория"
if (Test-Path -Path $RepoPath) {
    if (-not (Test-Path -Path (Join-Path $RepoPath ".git"))) {
        throw "Папка '$RepoPath' уже существует, но это не git-репозиторий. Переименуйте/удалите папку и запустите скрипт снова."
    }

    Write-Host "Найден существующий git-репозиторий."
} else {
    Write-Host "Клонирую: $RepoUrl"
    git clone $RepoUrl $RepoPath
}

Write-Step "Проверка состояния репозитория"
Push-Location $RepoPath
try {
    $remoteUrl = git remote get-url origin
    Write-Host "origin: $remoteUrl"

    $branch = git branch --show-current
    if ([string]::IsNullOrWhiteSpace($branch)) {
        Write-Warn "Не удалось определить текущую ветку."
    } else {
        Write-Host "Текущая ветка: $branch"
    }

    if (-not $SkipPull) {
        Write-Host "Выполняю git pull --rebase..."
        git pull --rebase
    } else {
        Write-Host "Шаг pull пропущен (параметр -SkipPull)."
    }

    Write-Host "Текущее состояние:"
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
