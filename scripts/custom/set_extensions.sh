#!/bin/bash
mkdir ~/.local/share/gnome-shell/extensions
cp -r ../../extensions/backup/* ~/.local/share/gnome-shell/extensions/
dconf load /org/gnome/shell/extensions/ < ../../extensions/settings_backup.txt