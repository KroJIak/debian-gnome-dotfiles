# Dotfiles
## Introduction
This repository was created to quickly install my settings, configs and applications on Debian Gnome. This dotfile parodies the capabilities of bspwm (switching desktops, disabling minimize buttons, closing windows, etc.), but leaves the original settings and applications native to gnome.
## About
- **Distro:** Debian 12 (bookworm)
- **Display Server:** X11
- **Display Manager:** GDM
- **Desktop Environment:** Gnome 43.9

![Desktop view](assets/desktop.png)
- **Terminal:** Kitty
- **CLI Shell:** Fish
- **File Manager:** Nautilus

![Terminal view](assets/terminal.png)
- **Sound Mixer:** PulseAudio
- **Task Manager:** btop++

![btop++ view](assets/btop.png)

- **Media Player:** MPV
- **GTK Theme:** Orchis green dark

![alt text](assets/media-player-and-theme.png)
- **Web Browser:** Firefox
- **Torrent Client:** qBitTorrent
- **Quick Access Toolbar (Dock replacement):** Gnome pie

![Gnome pie view](assets/gnome-pie.gif)
## Setup

## Keybinds
Keybinds were made based on the names of applications or associations with them. To launch the rest of the applications, `gnome pie` or search is used (clicking on win and entering the name).
- **`Super + Enter`** Launch terminal
- **`Alt + A`** Launch Gnome pie
- **`Super + Q`** Close window
- **`Super + W`** Launch Web Browser
- **`Super + E`** Launch Nautilus
- **`Super + T`** Launch Telegram
- **`Super + Y`** Launch Yandex music
- **`Super + O`** Launch Obsidian
- **`Super + P`** Change the monitor mode
- **`Super + A`** Minimize the window
- **`Super + S`** Launch Settings
- **`Super + D`** Launch Discord
- **`Super + K`** Log Out
- **`Super + L`** Lockscreen
- **`Super + ;`** Power off
- **`Super + C`** Launch Calculator
- **`Super + B`** Launch btop++
- **`Super + Tab`** Change the window in the current workspace
- **`Super + {number}`** Switch to the `{number}` workspace
- **`Super + Shift + {number}`** Move the window to the {number} workspace
- **`Alt + Tab`** Change the window on all workspaces
- **`PrtSc`** Take screenshot using flameshot
- **`Shift + PrtSc`** Open flameshot settings
- **`Super + LMB`** Move window
- **`Super + MMB`** Resize window

## Credits
Some material was taken from other repositories and has been slightly modified:
- [Debian bspwm dotfiles](https://github.com/addy-dclxvi/debian-bspwm-dotfiles) | **Author:** [addy-dclxvi](https://github.com/addy-dclxvi) | **Taken:** background image, `kitty` config, `fish` config, some keybinds
- [Orchis theme](https://github.com/vinceliuice/Orchis-theme) | **Author:** [vinceliuice](https://github.com/vinceliuice) | **Taken:** green dark theme
- [Huawei ubuntu sound fix](https://github.com/Smoren/huawei-ubuntu-sound-fix) | **Author:** [Smoren](https://github.com/Smoren) | **Info:** for huawei 14s / 16s users (also work with Debian)
- [plymouth themes](https://github.com/adi1090x/plymouth-themes) | **Author:** [adi1090x](https://github.com/adi1090x) | **Taken:** used `cubes` theme from pack 1