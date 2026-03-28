# macOS Setup with Ansible

Automated setup for a new macOS machine using Ansible.

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/handriss/ansible/main/bootstrap.sh | bash
```

## Run Playbook

```bash
ansible-playbook local.yml --ask-vault-pass
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

### Cloud CLIs
- Google Cloud SDK

### Window Management
- yabai (tiling window manager)
- skhd (hotkey daemon)

### Apps
- WebStorm
- GoLand
- DataGrip
- Google Chrome

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
│   ├── nvim/
│   ├── yabairc
│   └── skhdrc
├── .ssh/               # SSH keys (vault-encrypted)
└── tasks/
    ├── ssh.yml
    ├── terminal.yml
    ├── git.yml
    ├── yabai.yml
    ├── nvm.yml
    ├── python.yml
    ├── go.yml
    ├── neovim.yml
    ├── docker.yml
    ├── devtools.yml
    └── apps.yml
```

## Vault-Encrypted Files

Sensitive files are encrypted with Ansible Vault:
- `.ssh/id_rsa` - SSH private key

To edit encrypted files:
```bash
ansible-vault edit .ssh/id_rsa
```

## Dry Run

Preview changes without applying:
```bash
ansible-playbook local.yml --check --ask-vault-pass
```

## Requirements

- macOS (Darwin)
- The bootstrap script installs: Xcode CLI tools, Homebrew, Ansible
