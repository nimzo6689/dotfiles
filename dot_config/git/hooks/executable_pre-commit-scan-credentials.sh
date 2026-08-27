#!/usr/bin/env nu

const SCRIPT_NAME = "[GlobalHook:scan-credentials]"

if (which gitleaks | is-not-empty) {
    let result = (gitleaks git --staged --verbose | complete)
    
    if $result.exit_code != 0 {
        print $"($SCRIPT_NAME) ERROR: 秘密情報の混入を検知しました。"
        exit 1
    }
} else {
    print $"($SCRIPT_NAME) WARNING: gitleaks がインストールされていないためスキップします。"
}

exit 0ss
