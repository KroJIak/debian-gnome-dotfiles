#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

mkdir -p "$HOME/.config"

shopt -s nullglob
for src in "$REPO_ROOT/config"/*; do
	name="$(basename "$src")"
	dest="$HOME/.config/$name"
	if [ -e "$dest" ]; then
		mv "$dest" "$HOME/.config/${name}.bak"
	fi
	cp -r "$src" "$dest"
done