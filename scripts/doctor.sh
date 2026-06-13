#!/bin/bash
# doctor.sh — report drift between live machine and repo's intended state.
# Read-only. Never modifies anything.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

OK="\033[32m✓\033[0m"
BAD="\033[31m✗\033[0m"
WARN="\033[33m!\033[0m"

drift=0

bump() { drift=$((drift + 1)); }

check_config() {
    local live="$1"
    local tracked="$2"
    if [ ! -e "$live" ]; then
        printf "  %b missing: %s\n" "$BAD" "$live"; bump
    elif diff -q "$live" "$tracked" >/dev/null 2>&1; then
        printf "  %b %s\n" "$OK" "$live"
    else
        printf "  %b %s differs from %s\n" "$WARN" "$live" "$tracked"; bump
    fi
}

check_service() {
    local svc="$1"
    local label="$2"
    if launchctl list 2>/dev/null | grep -q "$label"; then
        printf "  %b %s running\n" "$OK" "$svc"
    else
        printf "  %b %s not running (no launchd job %s)\n" "$BAD" "$svc" "$label"; bump
    fi
}

echo "macOS setup doctor — drift report"
echo "Repo: $REPO_DIR"
echo

# 1. Brewfile coverage
if [ ! -f Brewfile ]; then
    printf "%b Brewfile missing — skipping brew/cask drift checks\n\n" "$BAD"
else
    expected_brews=$(awk -F'"' '/^brew /{print $2}' Brewfile | sort -u)
    installed_brews=$(brew leaves 2>/dev/null | sort -u)

    missing=$(comm -23 <(echo "$expected_brews") <(echo "$installed_brews"))
    extra=$(comm -13 <(echo "$expected_brews") <(echo "$installed_brews"))

    echo "=== Brew formulae ==="
    if [ -z "$missing" ] && [ -z "$extra" ]; then
        printf "  %b all expected formulae installed, no extras\n" "$OK"
    else
        [ -n "$missing" ] && printf "  %b missing:\n" "$BAD" && echo "$missing" | sed 's/^/      /' && bump
        [ -n "$extra" ] && printf "  %b extra (installed but not in Brewfile):\n" "$WARN" && echo "$extra" | sed 's/^/      /'
    fi
    echo

    expected_casks=$(awk -F'"' '/^cask /{print $2}' Brewfile | sort -u)
    installed_casks=$(brew list --cask 2>/dev/null | sort -u)

    missing=$(comm -23 <(echo "$expected_casks") <(echo "$installed_casks"))
    extra=$(comm -13 <(echo "$expected_casks") <(echo "$installed_casks"))

    echo "=== Brew casks ==="
    if [ -z "$missing" ] && [ -z "$extra" ]; then
        printf "  %b all expected casks installed, no extras\n" "$OK"
    else
        [ -n "$missing" ] && printf "  %b missing:\n" "$BAD" && echo "$missing" | sed 's/^/      /' && bump
        [ -n "$extra" ] && printf "  %b extra (installed but not in Brewfile):\n" "$WARN" && echo "$extra" | sed 's/^/      /'
    fi
    echo
fi

# 2. Services
echo "=== Services ==="
check_service yabai com.koekeishiya.yabai
check_service skhd com.koekeishiya.skhd
check_service karabiner org.pqrs.service.agent.karabiner_console_user_server
echo

# 3. Tracked config files
echo "=== Tracked configs ==="
check_config "$HOME/.zshrc" "files/.zshrc"
check_config "$HOME/.p10k.zsh" "files/.p10k.zsh"
check_config "$HOME/.gitconfig" "files/.gitconfig"
check_config "$HOME/.config/karabiner/karabiner.json" "files/karabiner.json"
check_config "$HOME/.config/tmux/tmux.conf" "files/tmux.conf"
check_config "$HOME/.config/yabai/yabairc" "files/yabairc"
check_config "$HOME/.config/skhd/skhdrc" "files/skhdrc"
check_config "$HOME/.config/nvim/init.lua" "files/nvim/init.lua"
echo

# 4. Summary
if [ "$drift" -eq 0 ]; then
    printf "%b No drift detected.\n" "$OK"
else
    printf "%b %d drift item(s) found.\n" "$WARN" "$drift"
fi
