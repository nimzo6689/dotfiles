Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($PSVersionTable.PSVersion.Major -ge 7) {
    $PSNativeCommandUseErrorActionPreference = $true
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
    } else {
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
    Invoke-Expression (& mise activate pwsh --shims)
}

# --- メイン処理の実行 ---
Test-EnvironmentVariables
Install-Scoop
Install-ScoopPackages
Install-VSCodeExtensions
Initialize-Mise
Initialize-Chezmoi
