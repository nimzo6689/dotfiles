if status is-interactive
# Commands to run in interactive sessions can go here
end

/home/nimzo/.local/bin/mise activate fish | source # added by https://mise.run/fish

eval (oh-my-posh init fish --config ~/.cache/oh-my-posh/themes/emodipt.omp.json)
zoxide init fish | source
