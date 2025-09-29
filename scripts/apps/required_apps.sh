#!/bin/bash

sudo snap install btop
sudo apt install -y pulseaudio curl rsync gnome-shell-extensions zip tree make
sudo apt install -y dconf-editor grub-customizer git neofetch mpv gnome-shell-extension-manager chrome-gnome-shell

sudo apt remove gnome-screenshot && sudo apt install -y flameshot
