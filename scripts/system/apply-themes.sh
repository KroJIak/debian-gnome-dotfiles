#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/../../gtk-theme"

mkdir -p "$HOME/.themes"
cp -r "$THEMES_DIR/Everforest-Dark-Medium-B-GS" "$HOME/.themes/"
cp -r "$THEMES_DIR/Everforest-Green-Dark" "$HOME/.themes/"

gsettings set org.gnome.desktop.interface gtk-theme 'Everforest-Green-Dark'
gsettings set org.gnome.shell.extensions.user-theme name 'Everforest-Dark-Medium-B-GS'

if command -v gnome-extensions >/dev/null 2>&1; then
	if gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com >/dev/null 2>&1; then
		if ! gnome-extensions list --enabled | grep -q '^user-theme@gnome-shell-extensions.gcampax.github.com$'; then
			echo "Warning: user-theme extension is installed but not enabled." >&2
		fi
	else
		echo "Warning: user-theme extension is not installed; Shell theme may not apply." >&2
	fi
else
	echo "Warning: gnome-extensions not found; cannot verify user-theme extension." >&2
fi