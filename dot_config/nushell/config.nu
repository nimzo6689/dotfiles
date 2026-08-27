# -------------------------
# 外部ツールの初期化
# -------------------------
# mise
use ($nu.default-config-dir | path join mise.nu)
$env.PATH = ($env.PATH | prepend "~/.local/share/mise/shims")

# oh-my-posh
oh-my-posh init nu --config emodipt | save -f ~/.cache/oh-my-posh.nu
source ~/.cache/oh-my-posh.nu

# zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu

# carapace
source $"($nu.cache-dir)/carapace.nu"

# -------------------------
# カスタムコマンド
# -------------------------
def --env mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

def --env reload [] {
    source $nu.env-path
    source $nu.config-path
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
