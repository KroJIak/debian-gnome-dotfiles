#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

rm -rf "$HOME/Desktop" "$HOME/Music" "$HOME/Pictures" "$HOME/Public" "$HOME/Templates" "$HOME/Videos"
mkdir -p "$HOME/Media"

mkdir -p "$HOME/.config"
cp "$SCRIPT_DIR/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
cp "$SCRIPT_DIR/user-dirs.locale" "$HOME/.config/user-dirs.locale"

xdg-user-dirs-update