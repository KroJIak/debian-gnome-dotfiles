#!/bin/bash

sudo snap install btop
sudo apt install -y dconf-editor fish gnome-pie grub-customizer kitty pulseaudio curl git neofetch mpv openvpn network-manager-openvpn-gnome


# Change the default shell to fish
sudo chsh $USER -s /usr/bin/fish

sudo apt remove gnome-screenshot && sudo apt install -y flameshot
