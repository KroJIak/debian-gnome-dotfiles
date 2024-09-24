#!/bin/bash
mkdir ~/.local/share/gnome-shell/extensions
cp -r ../../extensions/backup/* ~/.local/share/gnome-shell/extensions/
dconf load /org/gnome/shell/extensions/ < ../../extensions/settings_backup.txt

gnome-extensions enable just-perfection-desktop@just-perfection
gnome-extensions enable mediacontrols@cliffniff.github.com
gnome-extensions enable logomenu@aryan_k
gnome-extensions enable tiling-assistant@leleat-on-github
gnome-extensions enable quicksettings-audio-devices-hider@marcinjahn.com
gnome-extensions enable Vitals@CoreCoding.com
gnome-extensions enable quick-settings-avatar@d-go
gnome-extensions enable top-bar-organizer@julian.gse.jsts.xyz
gnome-extensions enable quick-settings-tweaks@qwreey
gnome-extensions enable Bluetooth-Battery-Meter@maniacx.github.com
gnome-extensions enable blur-my-shell@aunetx
gnome-extensions enable trayIconsReloaded@selfmade.pl
gnome-extensions enable block-caribou-36@lxylxy123456.ercli.dev
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com