#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

run_cmd "apt update" sudo apt update -qq
run_cmd "apt upgrade" sudo apt upgrade $APT_YES_FLAG -qq
run_cmd "install qbittorrent" sudo apt install $APT_YES_FLAG -qq qbittorrent
run_cmd "install czkawka" sudo snap install czkawka
run_cmd "install pdfarranger" sudo apt install $APT_YES_FLAG -qq pdfarranger
run_cmd "install IntelliJ IDEA Ultimate" sudo snap install intellij-idea-ultimate --classic
run_cmd "install Obsidian" sudo snap install obsidian --classic
run_cmd "install Discord" sudo snap install discord

if [[ "${DOTFILES_AUTO_YES:-0}" -eq 1 ]]; then
	reply="y"
else
	read -r -p "Install Ayugram Desktop instead of Telegram Desktop? (y/N) " reply
fi
if [[ "$reply" =~ ^[Yy]$ ]]; then
	bash "$SCRIPT_DIR/extra/70-ayugram-desktop.sh"
else
	run_cmd "install Telegram Desktop" sudo snap install telegram-desktop
fi

bash "$SCRIPT_DIR/extra/40-docker.sh"
bash "$SCRIPT_DIR/extra/50-yandex-music.sh"
bash "$SCRIPT_DIR/extra/55-vscode.sh"
bash "$SCRIPT_DIR/extra/redvpn/install.sh" --quiet --skip-key-input
bash "$SCRIPT_DIR/extra/75-tailscale.sh"
bash "$SCRIPT_DIR/extra/80-arduino.sh"