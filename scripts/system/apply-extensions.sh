#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

host_user="$(id -un)"
host_name="$(hostname)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p "$tmp_dir/extensions"
cp -r "$REPO_ROOT/extensions/backup/." "$tmp_dir/extensions/"
cp "$REPO_ROOT/extensions/settings_backup.txt" "$tmp_dir/settings_backup.txt"

if command -v perl >/dev/null 2>&1; then
	find "$tmp_dir" -type f -print0 | xargs -0 perl -pi -e "s/__USER__/${host_user}/g; s/__HOST__/${host_name}/g"
else
	find "$tmp_dir" -type f -print0 | xargs -0 sed -i "s/__USER__/${host_user}/g; s/__HOST__/${host_name}/g"
fi

mkdir -p "$HOME/.local/share/gnome-shell/extensions"
cp -r "$tmp_dir/extensions/." "$HOME/.local/share/gnome-shell/extensions/"
dconf load /org/gnome/shell/extensions/ < "$tmp_dir/settings_backup.txt"