Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($PSVersionTable.PSVersion.Major -ge 7) {
    $PSNativeCommandUseErrorActionPreference = $true
}

$env:GITHUB_TOKEN = 'YOUR_GITHUB_TOKEN'
$env:GITHUB_USERNAME = 'YOUR_GITHUB_USERNAME'

if ($env:GITHUB_TOKEN -eq 'YOUR_GITHUB_TOKEN') {
    Write-Error 'Please set your GitHub token in the script.'
    exit 1
}

if ($env:GITHUB_USERNAME -eq 'YOUR_GITHUB_USERNAME') {
    Write-Error 'Please set your GitHub username in the script.'
    exit 1
}

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iwr -useb get.scoop.sh | iex
}

scoop install git

scoop install mise chezmoi
Invoke-Expression (& mise activate pwsh --shims)

# chezmoi のセットアップ
chezmoi init --apply --force "$env:GITHUB_USERNAME"

# 各ツールのセットアップ
mise run setup
if ($LASTEXITCODE -ne 0) {
    Write-Warning "mise run setup failed, continuing..."
}
