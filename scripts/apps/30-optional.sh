#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y qbittorrent
sudo apt install -y czkawka
sudo apt install -y pdfarranger
sudo snap install intellij-idea-ultimate --classic
sudo snap install obsidian --classic
sudo snap install discord

if [[ "${DOTFILES_AUTO_YES:-0}" -eq 1 ]]; then
	reply="y"
else
	read -r -p "Install Ayugram Desktop instead of Telegram Desktop? (y/N) " reply
fi
if [[ "$reply" =~ ^[Yy]$ ]]; then
	bash "$SCRIPT_DIR/extra/70-ayugram-desktop.sh"
else
	sudo snap install telegram-desktop
fi

bash "$SCRIPT_DIR/extra/40-docker.sh"
bash "$SCRIPT_DIR/extra/50-yandex-music.sh"
bash "$SCRIPT_DIR/extra/55-vscode.sh"
bash "$SCRIPT_DIR/extra/redvpn/install.sh" --quiet --skip-key-input
bash "$SCRIPT_DIR/extra/75-tailscale.sh"
bash "$SCRIPT_DIR/extra/80-arduino.sh"