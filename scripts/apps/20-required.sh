#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo snap install btop
sudo apt install -y \
	dconf-editor grub-customizer pulseaudio \
    curl git neofetch mpv openvpn \
    network-manager-openvpn-gnome gcolor3 \
    gnome-shell-extensions rsync zip tree \
    make locate gnome-shell-extension-manager \
    chrome-gnome-shell
sudo flatpak install -y flathub io.github.seadve.Kooha

bash "$SCRIPT_DIR/extra/60-flameshot.sh"
bash "$SCRIPT_DIR/extra/65-ipscan.sh"