#!/bin/bash

sudo snap install btop
sudo apt install -y dconf-editor fish gnome-pie grub-customizer kitty pulseaudio curl git neofetch

# Change the default shell to fish
chsh $USER -s /usr/bin/fish

sudo apt remove gnome-screenshot && sudo apt install -y flameshot