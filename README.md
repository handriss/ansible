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
- tmux with Catppuccin theme and plugins (TPM, resurrect, continuum)

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
│   ├── tmux.conf
│   ├── yabairc
│   ├── skhdrc
│   └── aws/
├── .ssh/               # SSH keys (vault-encrypted)
├── .aws/               # AWS credentials (vault-encrypted)
└── tasks/
    ├── ssh.yml
    ├── terminal.yml
    ├── tmux.yml
    ├── git.yml
    ├── yabai.yml
    ├── nvm.yml
    ├── python.yml
    ├── go.yml
    ├── ruby.yml
    ├── neovim.yml
    ├── docker.yml
    ├── devtools.yml
    └── apps.yml
```

## Vault-Encrypted Files

Sensitive files are encrypted with Ansible Vault:
- `.ssh/id_rsa` - SSH private key
- `.aws/credentials` - AWS credentials

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
