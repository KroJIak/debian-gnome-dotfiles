# Debian GNOME Dotfiles

## Overview
- **Distro:** Debian 13
- **Display server:** X11
- **Display manager:** GDM
- **Desktop environment:** GNOME 48
- **Terminal:** Tilix
- **Shell:** Zsh + Starship
- **File manager:** Nautilus
- **Shell theme:** Everforest Dark Medium B GS (Custom fork)
- **GTK theme (legacy apps):** Everforest Green Dark (Custom fork)

## Screenshots
Placeholders for new screenshots:
- assets/screenshots/desktop.png
- assets/screenshots/terminal.png
- assets/screenshots/overview.png
- assets/screenshots/quick-settings.png
- assets/screenshots/plymouth.png

## Repository Layout
- **Install stages:** [scripts/install](scripts/install)
- **Apps:** [scripts/apps](scripts/apps)
- **System:** [scripts/system](scripts/system)
- **Fixes:** [scripts/fixes](scripts/fixes)
- **Extensions backup:** [extensions](extensions)
- **Themes:** [gtk-theme](gtk-theme)
- **Plymouth files:** [grub-plymouth](grub-plymouth)

## Quick Install
### 1) Init submodules
```bash
git submodule update --init --recursive
```

### 2) Run installer
```bash
./install.sh
```

### Flags
- `--debug`
- `-y`, `--yes`
- `--skip-optional-apps`
- `--skip-fixes`
- `--skip-system`
- `--only-fixes`
- `--only-system`

Reboot after install.

## Manual Stages
### Stage 1: Apps
- Remove GNOME bloat: [scripts/apps/00-remove-gnome-bloat.sh](scripts/apps/00-remove-gnome-bloat.sh)
- Install snap: [scripts/apps/10-snapd.sh](scripts/apps/10-snapd.sh)
- Install flatpak: [scripts/apps/15-flatpak.sh](scripts/apps/15-flatpak.sh)
- Required apps: [scripts/apps/20-required.sh](scripts/apps/20-required.sh)
- Optional apps: [scripts/apps/30-optional.sh](scripts/apps/30-optional.sh)

### Stage 2: Fixes
- Huawei sound: [scripts/fixes/huawei-sound/install.sh](scripts/fixes/huawei-sound/install.sh)
- Huawei fn keys: [scripts/fixes/fnkeys/install.sh](scripts/fixes/fnkeys/install.sh)
- X11 fractional scaling: [scripts/fixes/x11-fractional-scaling/install.sh](scripts/fixes/x11-fractional-scaling/install.sh)

### Stage 3: System
- Images: [scripts/system/add-images.sh](scripts/system/add-images.sh)
- Configs: [scripts/system/apply-configs.sh](scripts/system/apply-configs.sh)
- Settings: [scripts/system/apply-settings.sh](scripts/system/apply-settings.sh)
- Extensions: [scripts/system/apply-extensions.sh](scripts/system/apply-extensions.sh)
- Enable extensions: [scripts/system/enable-extensions.sh](scripts/system/enable-extensions.sh)
- SSH config: [scripts/system/update-ssh-config.sh](scripts/system/update-ssh-config.sh)
- Plymouth: [scripts/system/grub/apply.sh](scripts/system/grub/apply.sh)
- Themes: [scripts/system/apply-themes.sh](scripts/system/apply-themes.sh)

## Apps (Highlights)
### Required
- Tilix, Zsh, Starship, FiraCode Nerd Font
- Flameshot, Kooha, btop
- GNOME extensions manager, dconf tools
- MPV, OpenVPN, Neofetch

### Optional
- Discord, Obsidian, IntelliJ IDEA Ultimate
- Telegram or Ayugram
- Docker, Yandex Music
- VS Code + extensions
- Arduino, RedVPN, Tailscale
- qBittorrent, Czkawka, PDF Arranger

## Extensions
### Sources
- [extensions/backup](extensions/backup)
- [extensions/settings_backup.txt](extensions/settings_backup.txt)

### Scripts
- [scripts/system/apply-extensions.sh](scripts/system/apply-extensions.sh)
- [scripts/system/enable-extensions.sh](scripts/system/enable-extensions.sh)

### Enabled extensions
- Vitals@CoreCoding.com
- block-caribou-36@lxylxy123456.ercli.dev
- blur-my-shell@aunetx
- clipboard-indicator@tudmotu.com
- custom-command-toggle@storageb.github.com
- gsconnect@andyholmes.github.io
- just-perfection-desktop@just-perfection
- mediacontrols@cliffniff.github.com
- pip-on-top@rafostar.github.com
- quick-settings-tweaks@qwreey
- quicksettings-audio-devices-hider@marcinjahn.com
- tiling-assistant@leleat-on-github
- top-bar-organizer@julian.gse.jsts.xyz
- trayIconsReloaded@selfmade.pl
- user-theme@gnome-shell-extensions.gcampax.github.com

## Notes
- **Placeholders:** `__USER__`, `__HOST__` are replaced during apply.
- **Reboot:** required after fixes and theme changes.
- **Optional apps:** Ayugram/Telegram, Docker, Yandex Music, VS Code extensions, RedVPN, Tailscale.

## Keybinds (Custom)
Defined in: [scripts/system/keybinds/keys/custom.txt](scripts/system/keybinds/keys/custom.txt)
- **Super+Return:** Tilix
- **Super+W:** Firefox
- **Super+E:** Nautilus
- **Super+T:** Telegram (or Ayugram if installed)
- **Super+Y:** Yandex Music
- **Super+O:** Obsidian
- **Super+V:** VS Code
- **Super+B:** btop (Tilix full screen)
- **Super+C:** Calculator
- **Super+D:** Discord
- **Super+S:** Settings
- **Super+K:** Log out
- **Print:** Flameshot GUI
- **Shift+Print:** Flameshot config
- **Ctrl+Print:** Kooha

## Credits
- Huawei sound fix: https://github.com/Smoren/huawei-ubuntu-sound-fix
- X11 fractional scaling: https://github.com/KroJIak/debian-gnome-x11-fractional-scaling.git
- Huawei fnkeys: https://github.com/KroJIak/huawei-fnkeys-debian-fix.git
- RedVPN client manager: https://github.com/KroJIak/redvpn-client-manager.git
- Plymouth themes: https://github.com/adi1090x/plymouth-themes
