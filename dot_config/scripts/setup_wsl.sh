#!/usr/bin/env bash

set -euo pipefail

export GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
GITHUB_USERNAME="YOUR_GITHUB_USERNAME"

if [[ $GITHUB_TOKEN == "YOUR_GITHUB_TOKEN" ]]; then
    echo "Please set your GitHub token in the script."
    exit 1
fi

if [[ $GITHUB_USERNAME == "YOUR_GITHUB_USERNAME" ]]; then
    echo "Please set your GitHub username in the script."
    exit 1
fi

# apt パッケージのセットアップ
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt install -y \
    software-properties-common \
    gnupg2 \
    build-essential \
    unzip \
    slirp4netns \
    fuse-overlayfs \
    uidmap

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
mise run setup || true
mise run enable-sudo-password
