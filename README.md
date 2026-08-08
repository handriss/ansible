# macOS Setup with Ansible

Automated setup for a new macOS machine using Ansible. It installs a specific,
opinionated toolchain and replaces several dotfiles with mine.

> **Read this before running it on a machine you care about.**
>
> This is my personal setup, published because it may be useful to read or fork —
> not as a general-purpose installer. Running it will:
>
> - **overwrite** `~/.zshrc`, `~/.p10k.zsh`, `~/.gitignore_global`, and the
>   `nvim` / `tmux` / `yabai` / `skhd` / `karabiner` configs under `~/.config`
>   (each is backed up alongside the original first)
> - install ~60 Homebrew packages and casks, and `brew trust` third-party taps
> - restart Dock, Finder and SystemUIServer to apply macOS defaults
> - install [Codeman](https://github.com/Ark0N/Codeman) as a launchd service on port 3300
> - amend `/etc/pam.d/sudo_local` to enable Touch ID for `sudo` (during bootstrap)
>
> It ships **no credentials**: it generates an SSH key rather than copying one,
> leaves `~/.aws` for you to configure, and only writes `.gitconfig` if you supply
> your own identity vars. Fork it and cut what you don't want.

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/handriss/ansible/main/bootstrap.sh | bash
```

## Run Playbook

```bash
ansible-playbook local.yml
```

## What Gets Installed

### Terminal & Shell
- Zsh with Powerlevel10k theme
- Meslo Nerd Font

### Development Tools
- neovim
- git
- Docker
- Terraform
- Claude Code

### Programming Languages
- Node.js (18, 20, 22 LTS via nvm)
- Python (3.12, 3.13 via pyenv)
- Go
- Ruby (3.3 via chruby)

### Cloud CLIs
- AWS CLI
- Google Cloud SDK

### Window Management
- yabai (tiling window manager)
- skhd (hotkey daemon)

### Apps
- WebStorm
- GoLand
- DataGrip
- PyCharm
- Google Chrome
- Tailscale, UTM, mitmproxy, IINA, Handy, OpenMTP, android-platform-tools
- Claude Desktop, Wispr Flow, Anki (adopted into Homebrew)
- Karabiner-Elements (+ config)
- App Store apps via mas (Xcode, Telegram, TestFlight, iWork, GarageBand, iMovie)

### Agents & Automation
- Codeman (mission control for Claude Code) + launchd service on port 3300
- Custom LaunchAgents: speechlab micwatcher/sync, caps-lock→escape remap
- Claude Code global config (CLAUDE.md, settings.json)

## Manual Installs (not tracked)

- **Hiddify** — no Homebrew cask; install from https://github.com/hiddify/hiddify-app
- **a client product** — own build
- **Mosyle MDM** — managed externally

Orphaned brew leaves deliberately not tracked: automake, bison, gdbm,
libffi, libmtp, librsvg, python@3.13 (pyenv covers Python).

## Project Structure

```
.
├── local.yml           # Main playbook
├── inventory           # Ansible inventory
├── ansible.cfg         # Ansible configuration
├── bootstrap.sh        # Prerequisites installer
├── files/              # Config files (non-sensitive)
│   ├── .zshrc
│   ├── .p10k.zsh
│   ├── .gitconfig
│   ├── yabairc
│   ├── skhdrc
│   └── aws/
├── .ssh/               # SSH keys (vault-encrypted)
├── .aws/               # AWS credentials (vault-encrypted)
└── tasks/
    ├── ssh.yml
    ├── terminal.yml
    ├── git.yml
    ├── yabai.yml
    ├── karabiner.yml
    ├── nvm.yml
    ├── python.yml
    ├── go.yml
    ├── ruby.yml
    ├── neovim.yml
    ├── docker.yml
    ├── devtools.yml
    ├── cli-tools.yml
    ├── cloud-k8s.yml
    ├── ai-tools.yml
    ├── claude.yml
    ├── apps.yml
    ├── mas.yml
    ├── launchagents.yml
    ├── macos.yml
    └── codeman.yml
```

## Secrets

This playbook ships **no** credentials. It generates an Ed25519 SSH key if you
don't have one, leaves `~/.aws` empty for you to configure with `aws configure
sso`, and renders `.gitconfig` from your own variables (see `vars/example.yml`).

Nothing here needs Ansible Vault.

## Dry Run

Preview changes without applying:
```bash
ansible-playbook local.yml --check
```

## Requirements

- macOS (Darwin)
- The bootstrap script installs: Xcode CLI tools, Homebrew, Ansible
