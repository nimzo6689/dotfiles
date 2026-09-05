# dotfiles

Chezmoi 用の dotfiles リポジトリです。

## Installation

以下の環境変数を設定してから、以下のコマンドを実行してください。

**GITHUB_TOKEN**  
GitHubのレートリミットを回避するために、Personal Access Token（PAT）を設定してください。

**GITHUB_USERNAME**
GitHubのユーザー名を設定してください。
このユーザー名は、chezmoi が GitHub から dotfiles を取得する際に使用されます。

**WSLENV**
`GITHUB_TOKEN:GITHUB_USERNAME` を WSL 環境に渡すために、WSLENV 環境変数を設定してください。

### Windows

PowerShell で以下のコマンドを実行してください。

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm https://raw.githubusercontent.com/nimzo6689/dotfiles/refs/heads/main/setup/windows.ps1 | iex
```

### WSL

Ubuntu 22.04 LTS 以降を想定しています。

```
curl -fsSL https://raw.githubusercontent.com/nimzo6689/dotfiles/refs/heads/main/setup/wsl.sh | bash
```
