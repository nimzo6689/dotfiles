#Requires -RunAsAdministrator
#Requires -Version 5.1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($PSVersionTable.PSVersion.Major -ge 7) {
    $PSNativeCommandUseErrorActionPreference = $true
}

function Initialize-PCSettings {
    # クリップボード履歴の有効化
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Clipboard" `
        -Name "EnableClipboardHistory" -Type DWord -Value 1

    # 拡張子を表示する
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
        -Name "HideFileExt" -Type DWord -Value 0

    # 長いパスの有効化
    Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' `
        -Name 'LongPathsEnabled' -Value 1

    # モニター ON/OFF
    # 電源駆動（ac）のときは何もするな黄猿。
    powercfg /X monitor-timeout-ac 0
    powercfg /X standby-timeout-ac 0
    # バッテリー駆動（dc）のときは 10 分で画面消して、60 分でスリープさせる。
    powercfg /X monitor-timeout-dc 10
    powercfg /X standby-timeout-dc 60
}

function Test-EnvironmentVariables {
    if (-not $env:GITHUB_TOKEN) {
        Write-Error 'Please set your GitHub token in the script.'
        exit 1
    }

    if (-not $env:GITHUB_USERNAME) {
        Write-Error 'Please set your GitHub username in the script.'
        exit 1
    }
}

function Install-Scoop {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod -Uri 'https://get.scoop.sh' | Invoke-Expression
    }
}

function Install-ScoopPackages {
    # extras バケットの追加
    scoop bucket add extras

    # aria2 のインストールと有効化
    scoop install aria2
    scoop config aria2-enabled true
    scoop config aria2-warning-enabled false

    # パッケージのまとめてインストール
    $scoopPackages = @(
        '7zip',
        'aria2',
        'aws',
        'dark',
        'git',
        'gsudo',
        'innounp',
        'less',
        'mise',
        'oh-my-posh',
        'rapidee',
        'sqlite',
        'tokei',
        'zoxide'
    )

    scoop install $scoopPackages
}

function Install-VSCodeExtensions {
    $extensions = @(
        "editorconfig.editorconfig",
        "esbenp.prettier-vscode",
        "ritwickdey.LiveServer",
        "mhutchie.git-graph",
        "ryu1kn.partial-diff",
        "ms-vscode-remote.remote-wsl",
        "ms-vscode-remote.remote-containers",
        "PKief.material-icon-theme"
    )

    $codeCommand = Get-Command code -ErrorAction SilentlyContinue
    if (-not $codeCommand) {
        $codeCommand = Get-Command code.cmd -ErrorAction SilentlyContinue
    }

    if ($codeCommand) {
        $installedExts = & $codeCommand.Source --list-extensions
        foreach ($ext in $extensions) {
            if ($installedExts -notcontains $ext) {
                & $codeCommand.Source --install-extension $ext --force
            }
        }
    }
    else {
        Write-Output "code command が見つからないため、VS Code 拡張機能のインストールをスキップします。"
    }
}

function Initialize-Chezmoi {
    # chezmoi が未インストールの場合は Scoop で補完
    if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
        scoop install chezmoi
    }
    chezmoi init --apply --force "$env:GITHUB_USERNAME"
}

function Initialize-Mise {
    # mise が未インストールの場合は Scoop で補完
    if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
        scoop install mise
    }
    Invoke-Expression (& mise activate pwsh --shims | Out-String)
}

# --- メイン処理の実行 ---
Initialize-PCSettings
Test-EnvironmentVariables
Install-Scoop
Install-ScoopPackages
Install-VSCodeExtensions
Initialize-Mise
Initialize-Chezmoi
