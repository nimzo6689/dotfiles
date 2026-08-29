# -------------------------
# 外部ツールの初期化
# -------------------------
# mise
use ($nu.default-config-dir | path join mise.nu)
$env.PATH = ($env.PATH | prepend "~/.local/share/mise/shims")

# zoxide
source $"($nu.cache-dir)/zoxide.nu"

# carapace
source $"($nu.cache-dir)/carapace.nu"

# -------------------------
# カスタムコマンド
# -------------------------
def --env mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

# -------------------------
# エイリアス設定
# -------------------------
# Git
alias g = git
alias gst = git status

# Mise (コマンドが存在する場合)
if (which mise | is-not-empty) {
    alias mu = mise use
    alias mug = mise use -g
}

# Podman (コマンドが存在する場合)
if (which podman | is-not-empty) {
    alias docker = podman
}
