#Requires -RunAsAdministrator
#Requires -Version 5.1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($PSVersionTable.PSVersion.Major -ge 7) {
    $PSNativeCommandUseErrorActionPreference = $true
}

# レジストリ値を冪等に設定するヘルパー関数
function Set-RegistryValueProperty {
    param (
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$PropertyType = "DWord"
    )

    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    $currentValue = Get-ItemPropertyValue -Path $Path -Name $Name -ErrorAction SilentlyContinue
    if ($null -eq $currentValue -or $currentValue -ne $Value) {
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $PropertyType -Force | Out-Null
    }
}

function Initialize-PCSettings {
    # クリップボード履歴の有効化
    Set-RegistryValueProperty -Path "HKCU:\Software\Microsoft\Clipboard" -Name "EnableClipboardHistory" -Value 1 -PropertyType DWord

    # 拡張子を表示する
    Set-RegistryValueProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -PropertyType DWord

    # 長いパスの有効化
    Set-RegistryValueProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWord

    # モニター ON/OFF
    # 電源駆動（ac）のときは何も設定しない（0=なし）
    powercfg /X monitor-timeout-ac 0
    powercfg /X standby-timeout-ac 0
    # バッテリー駆動（dc）のときは 10 分で画面消去、60 分でスリープ
    powercfg /X monitor-timeout-dc 10
    powercfg /X standby-timeout-dc 60
}

function Test-EnvironmentVariables {
    if (-not $env:GITHUB_TOKEN) {
        Write-Error 'Please set your GitHub token in the environment.'
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
    # extras バケットの存在チェックと追加
    $buckets = scoop bucket list
    if ($buckets -notcontains 'extras') {
        scoop bucket add extras
    }

    # インストール済みパッケージ一覧を取得
    $installedScoopApps = (scoop list | Select-Object -Skip 3 | ForEach-Object { ($_ -split '\s+')[0] })

    # aria2 のインストールと有効化
    if ($installedScoopApps -notcontains 'aria2') {
        scoop install aria2
    }

    # aria2 の設定を適用（必要に応じて更新）
    scoop config aria2-enabled true
    scoop config aria2-warning-enabled false

    # 未インストールのパッケージのみをフィルタリングして一括インストール
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

    $missingPackages = $scoopPackages | Where-Object { $installedScoopApps -notcontains $_ }

    if ($missingPackages.Count -gt 0) {
        Write-Host "Installing missing Scoop packages: $($missingPackages -join ', ')..."
        scoop install $missingPackages
    } else {
        Write-Host "All Scoop packages are already installed."
    }
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
        $installedExts = (& $codeCommand.Source --list-extensions) | ForEach-Object { $_.ToLower() }
        foreach ($ext in $extensions) {
            if ($installedExts -notcontains $ext.ToLower()) {
                Write-Host "Installing VS Code extension: $ext..."
                & $codeCommand.Source --install-extension $ext --force
            }
        }
    }
    else {
        Write-Output "code command が見つからないため、VS Code 拡張機能のインストールをスキップします。"
    }
}

function Initialize-Mise {
    $miseCommand = Get-Command mise -ErrorAction SilentlyContinue
    if ($miseCommand) {
        Invoke-Expression (& $miseCommand.Source activate pwsh --shims | Out-String)
    } else {
        Write-Warning "mise コマンドが見つかりませんでした。"
    }
}

# --- メイン処理の実行 ---
Initialize-PCSettings
Test-EnvironmentVariables
Install-Scoop
Install-ScoopPackages
Install-VSCodeExtensions
Initialize-Mise
