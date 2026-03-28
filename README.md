# macOS Setup

```bash
# 1. Install prerequisites (Xcode CLI tools, Homebrew, Ansible)
curl -fsSL https://raw.githubusercontent.com/handriss/ansible/main/bootstrap.sh | bash

# 2. Run playbook
ansible-playbook local.yml --ask-vault-pass
```
