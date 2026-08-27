#!/usr/bin/env nu

const SCRIPT_NAME = "[GlobalHook:check-large-files]"
const THRESHOLD = 5mb

# ステージングされたファイル一覧（追加・変更）を取得
let staged_files = (git diff --cached --name-only --diff-filter=ACM | lines)

for file in $staged_files {
    # ファイルが存在しない（削除済み等の）場合はスキップ
    if not ($file | path exists) {
        continue
    }

    let file_size = (ls $file | get size.0)

    if $file_size > $THRESHOLD {
        # Git LFS の設定を確認
        let attr_check = (git check-attr filter $file | complete)
        let is_lfs = ($attr_check.stdout | str contains "filter: lfs")

        if not $is_lfs {
            # 人間が読みやすい形式（例: 5.2 MB）に変換して出力
            let readable_size = ($file_size | into string)
            print $"($SCRIPT_NAME) ERROR: ($file) \(($readable_size)\) が制限を超えています。"
            print "Hint: LFSを設定するか、ファイルを削除してください。"
            exit 1
        }
    }
}

exit 0
