#!/usr/bin/env bash

set -euo pipefail

echo "=== Nu Shell のインストールを開始します ==="

# 1. GPGキーとリポジトリのセットアップ
GPG_KEY="/etc/apt/keyrings/fury-nushell.gpg"
REPO_LIST="/etc/apt/sources.list.d/fury-nushell.list"

if [ ! -f "$GPG_KEY" ] || [ ! -f "$REPO_LIST" ]; then
    sudo mkdir -p /etc/apt/keyrings

    if [ ! -f "$GPG_KEY" ]; then
        wget -qO- https://apt.fury.io/nushell/gpg.key | sudo gpg --yes --dearmor -o "$GPG_KEY"
    fi

    if [ ! -f "$REPO_LIST" ]; then
        DEB_LINE="deb [signed-by=$GPG_KEY] https://apt.fury.io/nushell/ /"
        echo "$DEB_LINE" | sudo tee "$REPO_LIST" > /dev/null
    fi

    sudo apt-get update
fi

# 2. パッケージが未インストールのときのみインストールを実行
if ! dpkg -s nushell >/dev/null 2>&1; then
    sudo apt-get install -y nushell
else
    echo "nushell は既にインストールされています。"
fi

echo "=== Nu Shell のインストール処理が完了しました ==="

echo "=== ubuntu_onchange.nu を実行します ==="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
nu "${SCRIPT_DIR}/ubuntu_onchange.nu"

echo "=== ubuntu_onchange.nu を実行しました ==="
