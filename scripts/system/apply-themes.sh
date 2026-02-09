#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"
THEMES_DIR="$SCRIPT_DIR/../../gtk-theme"

mkdir -p "$HOME/.themes"
cp -r "$THEMES_DIR/Everforest-Dark-Medium-B-GS" "$HOME/.themes/"
cp -r "$THEMES_DIR/Everforest-Green-Dark" "$HOME/.themes/"

gsettings set org.gnome.desktop.interface gtk-theme 'Everforest-Green-Dark'
gsettings set org.gnome.shell.extensions.user-theme name 'Everforest-Dark-Medium-B-GS'

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