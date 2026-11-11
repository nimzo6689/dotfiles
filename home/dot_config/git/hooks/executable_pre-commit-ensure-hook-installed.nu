#!/usr/bin/env nu

const SCRIPT_NAME = "[GlobalHook:ensure-hook-installed]"

# 設定ファイルがあり、かつフックの実体が存在しないかチェック
if ((".pre-commit-config.yaml" | path exists) and not (".git/hooks/pre-commit" | path exists)) {
    print $"($SCRIPT_NAME) ERROR: .pre-commit-config.yaml がありますが Hook が未登録です。"
    print "Hint: 'pre-commit install' を実行してください。"
    exit 1
}

exit 0
