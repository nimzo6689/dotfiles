# dotfiles

Chezmoi 用の dotfiles リポジトリです。  

## Installation

### Windows

PowerShell で以下のコマンドを実行してください。

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
~./config/scripts/setup_windows.ps1
```

### WSL

Ubuntu 22.04 LTS 以降を想定しています。

```bash
/mnt/c/Users/$USER/.config/scripts/setup_wsl.sh
```
