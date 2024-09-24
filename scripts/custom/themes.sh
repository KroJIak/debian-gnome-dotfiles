#!/bin/bash

git clone https://github.com/vinceliuice/Orchis-theme
cd Orchis-theme
bash install.sh --theme green --color dark --size standard
gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Green-Dark'
gsettings set org.gnome.shell.extensions.user-theme name 'Orchis-Green-Dark'
cd ..
sudo rm -r Orchis-theme

git clone --depth=1 https://github.com/realmazharhussain/gdm-tools
cd gdm-tools
sudo bash install.sh
set-gdm-theme backup update
set-gdm-theme set -b ~/.gdm_background2K.png
cd ..
sudo rm -r gdm-tools