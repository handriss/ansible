# Third-party taps (must be trusted by tasks/brewfile.yml first)
tap "koekeishiya/formulae"
tap "hashicorp/tap"

# CLI tools
brew "argocd"
brew "awscli"
brew "bat"
brew "mitmproxy"
brew "bun"
brew "git"
brew "go"
brew "jq"
brew "neovim"
brew "nmap"
brew "nvm"
brew "pipx"
brew "powerlevel10k"
brew "pyenv"
brew "semgrep"
brew "stow"
brew "tmux"
brew "tree"
brew "vim"
brew "virtualenv"

# Tools from trusted third-party taps
brew "hashicorp/tap/terraform"
brew "koekeishiya/formulae/skhd"
# yabai is installed from the asmvik fork via tasks/yabai.yml (current build,
# 7.1.25); do not also install koekeishiya/formulae/yabai — same formula from
# two taps collides.

# Apps and fonts
# `args: { adopt: true }` makes brew claim an existing manual install at the
# destination instead of failing. No effect on fresh installs.
cask "anki", args: { adopt: true }
cask "claude", args: { adopt: true }
cask "claude-code", args: { adopt: true }
cask "datagrip", args: { adopt: true }
cask "docker-desktop", args: { adopt: true }
cask "font-meslo-lg-nerd-font"
cask "gcloud-cli", args: { adopt: true }
cask "goland", args: { adopt: true }
cask "google-chrome", args: { adopt: true }
cask "karabiner-elements", args: { adopt: true }
cask "tailscale-app", args: { adopt: true }
cask "telegram", args: { adopt: true }
cask "vlc", args: { adopt: true }

# Merged in from tasks/apps.yml (also installed there; kept here so the
# Brewfile-only path doesn't miss them).
cask "handy", args: { adopt: true }
cask "wispr-flow", args: { adopt: true }
cask "webstorm", args: { adopt: true }
cask "iina", args: { adopt: true }
cask "utm", args: { adopt: true }
cask "openmtp", args: { adopt: true }
cask "android-platform-tools", args: { adopt: true }
