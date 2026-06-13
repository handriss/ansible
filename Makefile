.DEFAULT_GOAL := help
.PHONY: help setup bootstrap install check update

help:
	@echo "macOS setup playbook — available targets:"
	@echo ""
	@echo "  make setup      Fresh-Mac flow: bootstrap prerequisites + run playbook"
	@echo "  make bootstrap  Install prerequisites only (Xcode CLT, Homebrew, Ansible)"
	@echo "  make install    Run the playbook (assumes prerequisites are present)"
	@echo "  make check      Dry-run the playbook (shows what would change, no changes made)"
	@echo "  make update     brew update + brew upgrade, then re-run the playbook"
	@echo ""

setup: bootstrap install

bootstrap:
	./bootstrap.sh

install:
	ansible-playbook local.yml --ask-vault-pass

check:
	ansible-playbook local.yml --ask-vault-pass --check

update:
	brew update && brew upgrade
	ansible-playbook local.yml --ask-vault-pass
