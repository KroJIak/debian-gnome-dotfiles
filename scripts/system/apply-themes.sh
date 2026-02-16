#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"
THEMES_DIR="$REPO_ROOT/gtk-theme"

if [ ! -d "$THEMES_DIR" ]; then
	warn "gtk-theme directory not found, skipping theme installation"
	exit 0
fi

mkdir -p "$HOME/.themes"
mkdir -p "$HOME/.local/share/themes"

if [ -d "$THEMES_DIR/Everforest-Dark-Medium-B-GS" ]; then
	cp -r "$THEMES_DIR/Everforest-Dark-Medium-B-GS" "$HOME/.themes/"
	cp -r "$THEMES_DIR/Everforest-Dark-Medium-B-GS" "$HOME/.local/share/themes/"
else
	warn "Everforest-Dark-Medium-B-GS theme not found"
fi

if [ -d "$THEMES_DIR/Everforest-Green-Dark" ]; then
	cp -r "$THEMES_DIR/Everforest-Green-Dark" "$HOME/.themes/"
	cp -r "$THEMES_DIR/Everforest-Green-Dark" "$HOME/.local/share/themes/"
else
	warn "Everforest-Green-Dark theme not found"
fi

gsettings set org.gnome.desktop.interface gtk-theme 'Everforest-Green-Dark' 2>&1 | grep -v "Failed to load module" | grep -v "libgnutls" || true
gsettings set org.gnome.shell.extensions.user-theme name 'Everforest-Dark-Medium-B-GS' 2>&1 | grep -v "Failed to load module" | grep -v "libgnutls" || true

if command -v gnome-extensions >/dev/null 2>&1; then
	if gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com >/dev/null 2>&1; then
		if ! gnome-extensions list --enabled | grep -q '^user-theme@gnome-shell-extensions.gcampax.github.com$'; then
			warn "user-theme extension is installed but not enabled."
		fi
	else
		warn "user-theme extension is not installed; Shell theme may not apply."
	fi
else
	warn "gnome-extensions not found; cannot verify user-theme extension."
fi