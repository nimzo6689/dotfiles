#!/usr/bin/env nu

const sudoers_file = "/etc/sudoers.d/99-nopasswd-wsl"

def check-env [] {
    if ("GITHUB_TOKEN" not-in $env) or ($env.GITHUB_TOKEN | is-empty) {
        print "Please set your GitHub token in the script."
        exit 1
    }

    if ("GITHUB_USERNAME" not-in $env) or ($env.GITHUB_USERNAME | is-empty) {
        print "Please set your GitHub username in the script."
        exit 1
    }
}

def disable-sudo-password [] {
    if not ($sudoers_file | path exists) {
        print "Configuring passwordless sudo..."
        $"($env.USER) ALL=\(ALL\) NOPASSWD: ALL\n" | sudo tee $sudoers_file | ignore
        sudo chmod 0440 $sudoers_file
        sudo chown root:root $sudoers_file
        sudo visudo -cf $sudoers_file
    }
}

def setup-apt-system-packages [] {
    disable-sudo-password
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean -y
    sudo apt install -y ...[
        software-properties-common
        gnupg2
        build-essential
        unzip
        slirp4netns
        fuse-overlayfs
        uidmap
    ]
}

def setup-apt-packages [] {
    disable-sudo-password

    sudo add-apt-repository -y ppa:git-core/ppa
    sudo apt update
    sudo apt install -y git
}

def setup-snap-packages [] {
    disable-sudo-password

    if (which aws | is-empty) {
        sudo snap install aws-cli --classic
    }
}

def setup-mise [] {
    if (which mise | is-empty) {
        sudo add-apt-repository -y ppa:jdxcode/mise
        sudo apt update -y
        sudo apt install -y mise
    }
}

def setup-chezmoi [] {
    mise use -g chezmoi@latest
    ~/.local/share/mise/shims/chezmoi init --apply --force $env.GITHUB_USERNAME
}

def setup-mise-packages [] {
    mise install -y
}

def setup-vscode-extensions [] {
    if (which code | is-not-empty) {
        let extensions = [
            "editorconfig.editorconfig"
            "esbenp.prettier-vscode"
            "mhutchie.git-graph"
            "ryu1kn.partial-diff"
        ]
        
        let installed_exts = (code --list-extensions | lines | str lowercase)

        for ext in $extensions {
            if ($ext | str lowercase) not-in $installed_exts {
                code --install-extension $ext --force
            }
        }
    } else {
        print "code command が見つからないため、VS Code 拡張機能のインストールをスキップします。"
    }
}

def change-login-shell [] {
    let nu_path = (which nu | get 0?.path)

    if ($nu_path | is-empty) {
        print "nu コマンドが見つからないため、ログインシェルの変更をスキップします。"
        return
    }

    # /etc/shells に Nushell のパスが含まれていない場合は追加
    let shells = (open /etc/shells | lines)
    if $nu_path not-in $shells {
        print $"Adding ($nu_path) to /etc/shells..."
        $"($nu_path)\n" | sudo tee -a /etc/shells | ignore
    }

    # 現在のデフォルトシェルを取得して比較
    let current_shell = $env.SHELL?
    if $current_shell != $nu_path {
        print $"Changing default shell to ($nu_path)..."
        sudo chsh -s $nu_path $env.USER
    } else {
        print "Login shell is already set to nu."
    }
}

def main [] {
    check-env
    print "Starting WSL setup..."
        
    disable-sudo-password
    setup-apt-system-packages

    setup-apt-packages
    setup-mise
    setup-chezmoi
    setup-mise-packages
    setup-snap-packages
    setup-vscode-extensions
    change-login-shell


    print "WSL setup completed!"
}
