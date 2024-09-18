#!/bin/bash
sudo rm -r ~/.local/share/gnome-shell/extensions
cp -r local ~/.local/share/gnome-shell/extensions
sudo rm -r /usr/share/gnome-shell/extensions
sudo cp -r usr /usr/share/gnome-shell/extensions
