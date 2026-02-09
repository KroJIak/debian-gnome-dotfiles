#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo snap install btop
sudo apt install -y \
	dconf-editor grub-customizer pulseaudio curl git \
	neofetch mpv openvpn network-manager-openvpn-gnome

bash "$SCRIPT_DIR/extra/60-flameshot.sh"
