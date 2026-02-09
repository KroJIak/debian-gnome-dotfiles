#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

sudo rm /etc/default/grub
sudo cp "$SCRIPT_DIR/grub" /etc/default/
sudo update-grub

# make sure you have the packages for plymouth
sudo apt install -y plymouth

# after downloading or cloning themes, copy the selected theme in plymouth theme dir
sudo rm -r /usr/share/plymouth/themes/cubes
sudo cp -r "$REPO_ROOT/grub-theme" /usr/share/plymouth/themes/cubes

# install the new theme (angular, in this case)
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/cubes/cubes.plymouth 100

# select the theme to apply
sudo plymouth-set-default-theme cubes

# update initramfs
sudo update-initramfs -u