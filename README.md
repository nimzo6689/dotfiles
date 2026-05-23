# dotfiles

Chezmoi 用の dotfiles リポジトリです。  

## Installation

Ubuntu 22.04 LTS 以降を想定しています。
Windows 側に以下のスクリプトを配置し、 WSL 上で実行してください。

```bash
export GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
GITHUB_USERNAME="YOUR_GITHUB_USERNAME"

# mise のセットアップ
if ! command -v mise >/dev/null 2>&1; then
    sudo add-apt-repository -y ppa:jdxcode/mise
    sudo apt update -y
    sudo apt install -y mise
fi

eval "$(mise activate bash --shims)"

# chezmoi のセットアップ
mise use -g chezmoi@latest
chezmoi init --apply --force "$GITHUB_USERNAME"

# 各ツールのセットアップ
mise run setup-wsl || true
mise run enable-sudo-password
```
