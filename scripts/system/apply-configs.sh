#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

if [ ! -d "$REPO_ROOT/config" ]; then
	warn "config directory not found, skipping config installation"
	exit 0
fi

mkdir -p "$HOME/.config"

current_user="$(id -un)"
current_host="$(hostname)"

replace_placeholders() {
	local target="$1"
	local file
	while IFS= read -r -d '' file; do
		if grep -Iq . "$file"; then
			sed -i \
				-e "s/__USER__/${current_user//\//\\/}/g" \
				-e "s/__HOST__/${current_host//\//\\/}/g" \
				"$file"
		fi
	done < <(find "$target" -type f -print0)
}

shopt -s nullglob
for src in "$REPO_ROOT/config"/*; do
	name="$(basename "$src")"
	dest="$HOME/.config/$name"
	backup="$HOME/.config/${name}.bak"
	
	if [ -e "$dest" ]; then
		# Remove old backup if it exists
		if [ -e "$backup" ]; then
			rm -rf "$backup"
		fi
		mv "$dest" "$backup"
	fi
	cp -r "$src" "$dest"
	replace_placeholders "$dest"
done