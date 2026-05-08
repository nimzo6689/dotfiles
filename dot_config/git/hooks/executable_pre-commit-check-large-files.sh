#!/usr/bin/env 

set -euo pipefail

EXIT_SUCCESS=0
EXIT_FAILURE=1
SCRIPT_NAME="[GlobalHook:check-large-files]"
THRESHOLD=5242880 # 5MB

# ステージングされた追加・変更ファイルを確認
for file in $(git diff --cached --name-only --diff-filter=ACM); do
    [ ! -f "$file" ] && continue
    size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
    
    if [ "$size" -gt "$THRESHOLD" ]; then
        # LFSの属性定義（定義ベース）を確認
        if ! git check-attr filter "$file" | grep -q "filter: lfs"; then
            echo "${SCRIPT_NAME} ERROR: ${file} ($((${size}/1024/1024))MB) が制限を超えています。"
            echo "Hint: LFSを設定するか、ファイルを削除してください。"
            exit ${EXIT_FAILURE}
        fi
    fi
done

exit ${EXIT_SUCCESS}
