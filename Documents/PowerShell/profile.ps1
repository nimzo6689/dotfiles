Set-PSReadLineOption -EditMode Emacs

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/emodipt.omp.json" | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })
