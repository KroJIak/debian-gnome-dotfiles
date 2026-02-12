#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

host_user="$(id -un)"
host_name="$(hostname)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

if [ ! -d "$REPO_ROOT/extensions/backup" ]; then
	warn "extensions/backup directory not found, skipping extensions installation"
	exit 0
fi

if [ ! -f "$REPO_ROOT/extensions/settings_backup.txt" ]; then
	warn "extensions/settings_backup.txt not found, skipping extensions installation"
	exit 0
fi

mkdir -p "$tmp_dir/extensions"
cp -r "$REPO_ROOT/extensions/backup/." "$tmp_dir/extensions/"
cp "$REPO_ROOT/extensions/settings_backup.txt" "$tmp_dir/settings_backup.txt"

if command -v perl >/dev/null 2>&1; then
	find "$tmp_dir" -type f -print0 | xargs -0 perl -pi -e "s/__USER__/${host_user}/g; s/__HOST__/${host_name}/g"
else
	find "$tmp_dir" -type f -print0 | xargs -0 sed -i "s/__USER__/${host_user}/g; s/__HOST__/${host_name}/g"
fi

has_redvpn=0
has_tailscale=0
if command -v redvpn >/dev/null 2>&1; then
	has_redvpn=1
fi
if command -v tailscale >/dev/null 2>&1; then
	has_tailscale=1
fi

if [ $has_redvpn -eq 0 ] || [ $has_tailscale -eq 0 ]; then
	settings_file="$tmp_dir/settings_backup.txt"
	awk -v has_redvpn="$has_redvpn" -v has_tailscale="$has_tailscale" '
		BEGIN { in_custom = 0 }
		/^\[custom-command-toggle\]$/ { in_custom = 1; print; next }
		/^\[.*\]$/ { in_custom = 0; print; next }
		in_custom {
			if ($0 ~ /^numbuttons-setting=/) {
				if (has_redvpn == 0 && has_tailscale == 0) { print "numbuttons-setting=0"; next }
				print "numbuttons-setting=1"; next
			}

			if (has_redvpn == 0 && has_tailscale == 1) {
				if ($0 ~ /(RedVPN|redvpn)/) { next }
				if ($0 ~ /(entryrow1|entryrow2|entryrow3|entryrow4|checkcommand1|delaytime1|initialtogglestate1|keybinding1|runcommandatboot1|showindicator1|togglestate1|buttonclick1|closemenu1)-setting=/) { next }
				if ($0 ~ /^checkcommand2-setting=/) { sub(/checkcommand2/, "checkcommand1"); print; next }
				if ($0 ~ /^delaytime2-setting=/) { sub(/delaytime2/, "delaytime1"); print; next }
				if ($0 ~ /^entryrow12-setting=/) { sub(/entryrow12/, "entryrow1"); print; next }
				if ($0 ~ /^entryrow22-setting=/) { sub(/entryrow22/, "entryrow2"); print; next }
				if ($0 ~ /^entryrow32-setting=/) { sub(/entryrow32/, "entryrow3"); print; next }
				if ($0 ~ /^entryrow42-setting=/) { sub(/entryrow42/, "entryrow4"); print; next }
				if ($0 ~ /^initialtogglestate2-setting=/) { sub(/initialtogglestate2/, "initialtogglestate1"); print; next }
				if ($0 ~ /^keybinding2-setting=/) { sub(/keybinding2/, "keybinding1"); print; next }
				if ($0 ~ /^runcommandatboot2-setting=/) { sub(/runcommandatboot2/, "runcommandatboot1"); print; next }
				if ($0 ~ /^showindicator2-setting=/) { sub(/showindicator2/, "showindicator1"); print; next }
				if ($0 ~ /^togglestate2-setting=/) { sub(/togglestate2/, "togglestate1"); print; next }
				if ($0 ~ /(checkcommand2|delaytime2|entryrow12|entryrow22|entryrow32|entryrow42|initialtogglestate2|keybinding2|runcommandatboot2|showindicator2|togglestate2)-setting=/) { next }
			}

			if (has_redvpn == 1 && has_tailscale == 0) {
				if ($0 ~ /(tailscale|Tailscale)/) { next }
				if ($0 ~ /(checkcommand2|delaytime2|entryrow12|entryrow22|entryrow32|entryrow42|initialtogglestate2|keybinding2|runcommandatboot2|showindicator2|togglestate2)-setting=/) { next }
			}

			if (has_redvpn == 0 && has_tailscale == 0) {
				if ($0 ~ /(tailscale|Tailscale|redvpn|RedVPN)/) { next }
				if ($0 ~ /(checkcommand[12]|delaytime[12]|entryrow1|entryrow2|entryrow3|entryrow4|entryrow12|entryrow22|entryrow32|entryrow42|initialtogglestate[12]|keybinding[12]|runcommandatboot[12]|showindicator[12]|togglestate[12]|buttonclick1|closemenu1)-setting=/) { next }
			}
		}
		{ print }
	' "$settings_file" > "$settings_file.tmp"
	mv "$settings_file.tmp" "$settings_file"
fi

mkdir -p "$HOME/.local/share/gnome-shell/extensions"
cp -r "$tmp_dir/extensions/." "$HOME/.local/share/gnome-shell/extensions/"
dconf load /org/gnome/shell/extensions/ < "$tmp_dir/settings_backup.txt"