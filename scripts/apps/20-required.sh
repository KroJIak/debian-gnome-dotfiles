#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

run_cmd "install btop" sudo snap install btop
run_cmd "install required packages" sudo apt install $APT_YES_FLAG -qq \
	dconf-editor grub-customizer pulseaudio \
    curl git mpv openvpn \
    network-manager-openvpn-gnome gcolor3 \
    gnome-shell-extensions rsync zip tree \
    make locate gnome-shell-extension-manager \
    gnome-browser-connector
run_cmd "install Kooha" sudo flatpak install $APT_YES_FLAG flathub io.github.seadve.Kooha

bash "$SCRIPT_DIR/extra/60-flameshot.sh"
bash "$SCRIPT_DIR/extra/65-ipscan.sh"
bash "$SCRIPT_DIR/extra/85-ulauncher.sh"
bash "$SCRIPT_DIR/extra/zsh/install.sh"
bash "$SCRIPT_DIR/extra/tilix/install.sh"