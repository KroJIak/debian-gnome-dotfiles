#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

if [ ! -f "$SCRIPT_DIR/grub" ]; then
	error "grub config file not found in $SCRIPT_DIR"
	exit 1
fi

sudo rm /etc/default/grub
sudo cp "$SCRIPT_DIR/grub" /etc/default/
sudo update-grub

# make sure you have the packages for plymouth
run_cmd "install plymouth" sudo apt install $APT_YES_FLAG -qq plymouth
# after downloading or cloning themes, copy the selected theme in plymouth theme dir
if [ -d "$REPO_ROOT/grub-plymouth" ]; then
  sudo rm -rf /usr/share/plymouth/themes/cubes
  sudo cp -r "$REPO_ROOT/grub-plymouth" /usr/share/plymouth/themes/cubes
  # install the new theme (angular, in this case)
  sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/cubes/cubes.plymouth 100
  # select the theme to apply
  sudo plymouth-set-default-theme cubes
  # update initramfs 
  sudo update-initramfs -u
else
  warn "grub-plymouth directory not found, skipping plymouth theme installation"
fi