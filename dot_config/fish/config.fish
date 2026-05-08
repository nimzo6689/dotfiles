set -g fish_greeting ""
set -x EDITOR code

function mkcd
    mkdir -p $argv
    cd $argv
end

if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) > /dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
end

if test -f /usr/local/bin/aws_completer
    complete --command aws --no-files --arguments '(string split " " (env COMP_LINE=(commandline -pc) COMP_POINT=(string length (commandline -pc)) /usr/local/bin/aws_completer))'
end

/home/nimzo/.local/bin/mise activate fish | source

eval (oh-my-posh init fish --config emodipt)
zoxide init fish | source
