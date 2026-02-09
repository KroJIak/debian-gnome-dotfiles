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

if ! command -v tailscale >/dev/null 2>&1; then
	settings_file="$tmp_dir/settings_backup.txt"
	awk '
		BEGIN { in_custom = 0 }
		/^\[custom-command-toggle\]$/ { in_custom = 1; print; next }
		/^\[.*\]$/ { in_custom = 0; print; next }
		in_custom {
			if ($0 ~ /^numbuttons-setting=/) { print "numbuttons-setting=1"; next }
			if ($0 ~ /(tailscale|Tailscale)/) { next }
			if ($0 ~ /(checkcommand2|delaytime2|entryrow12|entryrow22|entryrow32|entryrow42|initialtogglestate2|keybinding2|runcommandatboot2|showindicator2|togglestate2)-setting=/) { next }
		}
		{ print }
	' "$settings_file" > "$settings_file.tmp"
	mv "$settings_file.tmp" "$settings_file"
fi

mkdir -p "$HOME/.local/share/gnome-shell/extensions"
cp -r "$tmp_dir/extensions/." "$HOME/.local/share/gnome-shell/extensions/"
dconf load /org/gnome/shell/extensions/ < "$tmp_dir/settings_backup.txt"