# remove apps from dock
gsettings set org.gnome.shell favorite-apps "[]"
# keybinds
bash keybinds/setup.sh
# dark theme
gsettings set org.gnome.desktop.interface color-scheme 'default'
# background
gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USER/.background2K.png"
#multitasking
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.mutter edge-tiling false
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
#battery
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.settings-daemon.plugins.power idle-dim true
gsettings set org.gnome.desktop.session idle-delay 900
gsettings get org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.desktop.interface show-battery-percentage true
#touchpad
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
#Large text
gsettings set org.gnome.desktop.interface text-scaling-factor 1.25