#!/usr/bin/env bash

set -euo pipefail

EXIT_SUCCESS=0
EXIT_FAILURE=1
SCRIPT_NAME="[GlobalHook:scan-credentials]"

if command -v gitleaks &> /dev/null; then
    if ! gitleaks git --staged --verbose; then
        echo "${SCRIPT_NAME} ERROR: 秘密情報の混入を検知しました。"
        exit ${EXIT_FAILURE}
    fi
else
    echo "${SCRIPT_NAME} WARNING: gitleaks がインストールされていないためスキップします。"
fi

exit ${EXIT_SUCCESS}
