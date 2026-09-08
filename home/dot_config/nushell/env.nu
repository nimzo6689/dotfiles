$env.EDITOR = "vim"
$env.config.show_banner = false

mkdir $nu.cache-dir

if $nu.is-login {
    if pwd != $nu.home-dir {
        cd $nu.home-dir
    }
}

# -------------------------
# 外部ツールの初期化
# -------------------------
# mise
let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force

# oh-my-posh
~/.local/share/mise/shims/oh-my-posh init nu --config emodipt

# zoxide
~/.local/share/mise/shims/zoxide init nushell | save -f $"($nu.cache-dir)/zoxide.nu"

# carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir $"($nu.cache-dir)"
~/.local/share/mise/shims/carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
