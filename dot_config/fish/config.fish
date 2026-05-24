set -g fish_greeting ""
set -x EDITOR code

# --------------------------------------
# Interactive Shell Setup
# --------------------------------------
if status is-interactive
    # AWS CLI の補完を有効化
    if test -f /usr/local/bin/aws_completer
        complete --command aws --no-files --arguments '(string split " " (env COMP_LINE=(commandline -pc) COMP_POINT=(string length (commandline -pc)) /usr/local/bin/aws_completer))'
    end

    # 既存のツール初期化をここにまとめる
    mise activate fish --shims | source
    oh-my-posh init fish --config emodipt | source
    zoxide init fish | source
end

# --------------------------------------
# Functions
# --------------------------------------
function mkcd
    if test (count $argv) -gt 0
        mkdir -p -- $argv[1]
        and cd $argv[1]
    else
        echo "Usage: mkcd <directory>"
    end
end

# --------------------------------------
# Aliases
# --------------------------------------
# Git
alias g='git'
alias gst='git status'

# Mise
if type -q mise
    alias mu='mise use'
    alias mug='mise use -g'
end

# eza
if type -q eza
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias lla='eza -la --icons --git'
end

# Podman
if type -q podman
    alias docker='podman'
end
