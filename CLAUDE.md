# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Ansible playbook for automating macOS machine setup. It runs locally against localhost and uses Ansible Vault for secrets.

## Running the Playbook

```bash
ansible-playbook local.yml --ask-vault-pass
```

## Prerequisites

- Homebrew must be installed first: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Install Ansible via Homebrew: `brew install ansible`

## Project Structure

- `local.yml` - Main playbook entry point, runs on localhost
- `tasks/` - Task files imported by the main playbook
- `.ssh/` - SSH keys (encrypted with Ansible Vault)

## Architecture

The playbook uses a pre_tasks block to verify Homebrew is installed before running tasks. Task files are organized in the `tasks/` directory and imported into the main playbook.
