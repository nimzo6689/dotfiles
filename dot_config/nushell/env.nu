$env.EDITOR = "vim"
$env.config.show_banner = false

# -------------------------
# 外部ツールの初期化
# -------------------------
# mise
let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force

# carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
