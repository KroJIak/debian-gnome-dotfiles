#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

# Helper to suppress libgnutls warnings from gsettings
gs() {
  gsettings "$@" 2>&1 | grep -v "Failed to load module" | grep -v "libgnutls" | grep -v "No such key" | grep -v "No such schema" | grep -v "^$" || true
}

# remove apps from dock
gs set org.gnome.shell favorite-apps "[]"

# keybinds
bash "$SCRIPT_DIR/keybinds/setup.sh"

gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']"

# home folders
bash "$SCRIPT_DIR/home-folders/apply.sh"

# dark theme
gs set org.gnome.desktop.interface color-scheme 'prefer-dark'

# background
if [ -f "$HOME/.background2K.png" ]; then
  gs set org.gnome.desktop.background picture-uri "file://$HOME/.background2K.png"
  gs set org.gnome.desktop.background picture-uri-dark "file://$HOME/.background2K.png"
else
  warn "Background image not found at $HOME/.background2K.png"
fi

# multitasking
gs set org.gnome.desktop.interface enable-hot-corners false
gs set org.gnome.mutter edge-tiling false
gs set org.gnome.mutter dynamic-workspaces false
gs set org.gnome.desktop.wm.preferences num-workspaces 4

# battery
gs set org.gnome.settings-daemon.plugins.power ambient-enabled false
gs set org.gnome.settings-daemon.plugins.power idle-dim true
gs set org.gnome.desktop.session idle-delay 900
gs set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gs set org.gnome.desktop.interface show-battery-percentage true

# touchpad
gs set org.gnome.desktop.peripherals.touchpad natural-scroll true
gs set org.gnome.desktop.peripherals.touchpad tap-to-click true
gs set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true

# large text
gs set org.gnome.desktop.interface text-scaling-factor 1.35

# disable minimize and close buttons
gs set org.gnome.desktop.wm.preferences button-layout :

# enable scrolling in firefox by touchscreen
echo "MOZ_USE_XINPUT2 DEFAULT=1" | sudo tee -a /etc/security/pam_env.conf

# max volume
gs set org.gnome.desktop.sound allow-volume-above-100-percent true
# disable event sounds
gs set org.gnome.desktop.sound event-sounds false

# middle click paste
gs set org.gnome.desktop.interface gtk-enable-primary-paste false

# right click on touchpad
gs set org.gnome.desktop.peripherals.touchpad click-method 'areas'

# clock weekday
gs set org.gnome.desktop.interface clock-show-weekday true

# clock seconds
gs set org.gnome.desktop.interface clock-show-seconds true

# center new windows
gs set org.gnome.mutter center-new-windows true

# disable hotkeys for dash to dock (if installed)
if gsettings list-schemas 2>/dev/null | grep -q "^org.gnome.shell.extensions.dash-to-dock$"; then
  gs set org.gnome.shell.extensions.dash-to-dock hot-keys false
fi