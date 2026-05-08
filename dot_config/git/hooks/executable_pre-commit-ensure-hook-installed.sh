#!/usr/bin/env bash

set -euo pipefail

EXIT_SUCCESS=0
EXIT_FAILURE=1
SCRIPT_NAME="[GlobalHook:ensure-hook-installed]"

# 設定ファイルがあるのに実体がない場合にエラー
if [ -f ".pre-commit-config.yaml" ] && [ ! -f ".git/hooks/pre-commit" ]; then
    echo "${SCRIPT_NAME} ERROR: .pre-commit-config.yaml がありますが Hook が未登録です。"
    echo "Hint: 'pre-commit install' を実行してください。"
    exit ${EXIT_FAILURE}
fi

exit ${EXIT_SUCCESS}
