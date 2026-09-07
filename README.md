# dotfiles

Chezmoi にて管理している dotfiles リポジトリです。  
Windows11 と WSL2(Ubuntu) の両方で使用できるように設定されています。  

## インストール方法

Windows の環境変数にて以下を設定してから、後続の手順を実行してください。  

**GITHUB_TOKEN**  
GitHubのレートリミットを回避するために、Personal Access Token（PAT）を設定してください。  
スコープ（権限）はすべて外したままで問題ありません。  

**WSLENV**
`GITHUB_TOKEN` を WSL 環境に渡すために、WSLENV 環境変数を設定してください。

### Windows

PowerShell で以下のコマンドを実行してください。

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
iwr get.scoop.sh | iex
scoop install git chezmoi

chezmoi init --apply nimzo6689
```

### WSL

Ubuntu 22.04 LTS 以降を想定しています。

```
sudo apt install -y chezmoi
chezmoi init --apply nimzo6689
```

## ツールの選定理由

[ADR](./docs/adr) を参照してください。
