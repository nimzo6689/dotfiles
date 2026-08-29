#!/usr/bin/env bash

set -euo pipefail

echo "=== Nu Shell のインストールを開始します ==="

sudo mkdir -p /etc/apt/keyrings

# https://www.nushell.sh/book/installation.html
# 「For Debian & Ubuntu:」を参照。

GPG_KEY=/etc/apt/keyrings/fury-nushell.gpg
if [ ! -f "$GPG_KEY" ]; then
    wget -qO- https://apt.fury.io/nushell/gpg.key | sudo gpg --yes --dearmor -o "$GPG_KEY"
    DEB_LINE="deb [signed-by=$GPG_KEY] https://apt.fury.io/nushell/ /"
    echo "$DEB_LINE" | sudo tee /etc/apt/sources.list.d/fury-nushell.list > /dev/null
fi
sudo apt update
sudo apt install -y nushell

echo "=== Nu Shell のインストールが完了しました ==="

echo "=== setup_wsl.nu を実行します ==="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
nu "${SCRIPT_DIR}/setup_wsl.nu"

echo "=== setup_wsl.nu を実行しました ==="
