#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

mkdir -p "$HOME/.local/share/gnome-shell/extensions"
cp -r "$REPO_ROOT/extensions/backup/." "$HOME/.local/share/gnome-shell/extensions/"
dconf load /org/gnome/shell/extensions/ < "$REPO_ROOT/extensions/settings_backup.txt"