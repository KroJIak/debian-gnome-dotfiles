#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for name in Desktop Music Pictures Public Templates Videos; do
	dir="$HOME/$name"
	backup="$HOME/${name}.bak"
	
	if [ -d "$dir" ]; then
		if [ -z "$(ls -A "$dir")" ]; then
			rmdir "$dir"
		else
			# Remove old backup if it exists
			if [ -e "$backup" ]; then
				rm -rf "$backup"
			fi
			mv "$dir" "$backup"
		fi
	fi
done

mkdir -p "$HOME/Media"

mkdir -p "$HOME/.config"

if [ -f "$SCRIPT_DIR/user-dirs.dirs" ]; then
	cp "$SCRIPT_DIR/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
else
	warn "user-dirs.dirs not found in $SCRIPT_DIR"
fi

if [ -f "$SCRIPT_DIR/user-dirs.locale" ]; then
	cp "$SCRIPT_DIR/user-dirs.locale" "$HOME/.config/user-dirs.locale"
else
	warn "user-dirs.locale not found in $SCRIPT_DIR"
fi

xdg-user-dirs-update