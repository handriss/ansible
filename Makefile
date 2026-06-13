.DEFAULT_GOAL := help
.PHONY: help setup bootstrap install check update doctor brew config defaults

help:
	@echo "macOS setup playbook — available targets:"
	@echo ""
	@echo "  make setup      Fresh-Mac flow: bootstrap prerequisites + run playbook"
	@echo "  make bootstrap  Install prerequisites only (Xcode CLT, Homebrew, Ansible)"
	@echo "  make install    Run the full playbook"
	@echo "  make check      Dry-run the playbook (no changes)"
	@echo "  make update     brew update + brew upgrade, then re-run the playbook"
	@echo "  make doctor     Report drift between live machine and repo (read-only)"
	@echo ""
	@echo "  Tag-scoped runs (subset of tasks):"
	@echo "    make brew      Install everything in Brewfile"
	@echo "    make config    Sync tracked dotfiles only"
	@echo "    make defaults  Apply macOS system defaults only"
	@echo "    make TAGS=foo  Run any custom tag combo (e.g. TAGS=yabai,karabiner)"
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

doctor:
	@./scripts/doctor.sh

brew:
	ansible-playbook local.yml --ask-vault-pass --tags=brew

config:
	ansible-playbook local.yml --ask-vault-pass --tags=config

defaults:
	ansible-playbook local.yml --ask-vault-pass --tags=defaults

# Pass through arbitrary tags: make tags TAGS=yabai,karabiner
tags:
	ansible-playbook local.yml --ask-vault-pass --tags="$(TAGS)"
