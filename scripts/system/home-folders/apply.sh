#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for name in Desktop Music Pictures Public Templates Videos; do
	dir="$HOME/$name"
	if [ -d "$dir" ]; then
		if [ -z "$(ls -A "$dir")" ]; then
			rmdir "$dir"
		else
			mv "$dir" "$HOME/${name}.bak"
		fi
	fi
done

mkdir -p "$HOME/Media"

mkdir -p "$HOME/.config"
cp "$SCRIPT_DIR/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
cp "$SCRIPT_DIR/user-dirs.locale" "$HOME/.config/user-dirs.locale"

xdg-user-dirs-update