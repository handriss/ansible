#!/bin/bash
set -e

# Install Xcode Command Line Tools if not installed
if ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please complete the Xcode installation prompt, then re-run this script."
    exit 0
else
    echo "Xcode Command Line Tools already installed"
fi

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH (different prefix on Apple Silicon vs Intel)
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

# Install Ansible if not installed
if ! command -v ansible &> /dev/null; then
    echo "Installing Ansible..."
    brew install ansible
else
    echo "Ansible already installed"
fi

# Install community.general collection for homebrew modules
if ! ansible-galaxy collection list community.general &> /dev/null; then
    echo "Installing Ansible community.general collection..."
    ansible-galaxy collection install community.general
fi

# Enable Touch ID for sudo so brew bundle's cask installers don't hang on the
# non-TTY password prompt. Done here (not in the playbook) because the playbook
# can't trigger Touch ID itself — Ansible's become invokes sudo with -n.
if [ ! -f /etc/pam.d/sudo_local ]; then
    echo "Enabling Touch ID for sudo..."
    echo 'auth       sufficient     pam_tid.so' | sudo tee /etc/pam.d/sudo_local > /dev/null
else
    echo "Touch ID for sudo already enabled"
fi

echo "Prerequisites installed successfully!"
echo "Run the playbook with: ansible-playbook local.yml --ask-vault-pass"
