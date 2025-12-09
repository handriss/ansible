#!/bin/bash
set -e

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
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

echo "Prerequisites installed successfully!"
