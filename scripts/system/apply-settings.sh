#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# remove apps from dock
gsettings set org.gnome.shell favorite-apps "[]"

# keybinds
bash "$SCRIPT_DIR/keybinds/setup.sh"

# home folders
bash "$SCRIPT_DIR/home-folders/apply.sh"

# dark theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# background
gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USER/.background2K.png"

# multitasking
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.mutter edge-tiling false
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

# battery
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.settings-daemon.plugins.power idle-dim true
gsettings set org.gnome.desktop.session idle-delay 900
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.desktop.interface show-battery-percentage true

# touchpad
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true

# large text
gsettings set org.gnome.desktop.interface text-scaling-factor 1.35

# disable minimize and close buttons
gsettings set org.gnome.desktop.wm.preferences button-layout :

# enable scrolling in firefox by touchscreen
echo "MOZ_USE_XINPUT2 DEFAULT=1" | sudo tee -a /etc/security/pam_env.conf

# max volume
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true

# middle click paste
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false

# right click on touchpad
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'

# clock weekday
gsettings set org.gnome.desktop.interface clock-show-weekday true

# clock seconds
gsettings set org.gnome.desktop.interface clock-show-seconds true

# center new windows
gsettings set org.gnome.mutter center-new-windows true

# disable hotkeys for dash to dock
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false