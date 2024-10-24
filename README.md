# Dotfiles
## Introduction
This repository was created to quickly install my settings, configs and applications on Debian Gnome. This dotfile parodies the capabilities of bspwm (switching desktops, disabling minimize buttons, closing windows, etc.), but leaves the original settings and applications native to gnome.
# About
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

![Media player and theme view](assets/media-player-and-theme.png)
- **Web Browser:** Firefox
- **Torrent Client:** qBitTorrent
- **Quick Access Toolbar (Dock replacement):** Gnome Pie

![Gnome pie view](assets/gnome-pie.gif)
# Setup
`total installation time:` **`21 minutes`**
## Debian Expert Installer
First, you need to install the Debian 12 image. The installation can be done via a USB flash drive.
Next, select the following options:
`Advanced options -> Expert install`
#### Choose language
- Language: `English`
- Country: `other -> Europe -> Russian Federation` (This method is used to select Russian as a secondary language)
- Default locale: `United States (en_US.UTF-8)`
- Other locale: `ru_RU.UTF-8`
- Select default locale: `en_US.UTF-8`
#### Detect and mount installation media
- Activate
#### Load installer components from installation media
- don't specify anything, just click `Continue`
#### Detect network hardware
- Activate
#### Configure the network
- Auto-configure networking?: `Yes`
- Just click `Continue`
- Hostname: измените его на то, что вы хотите (например, `"andrey-debian"`)
- Domain name: `Continue`
#### Set up users and passwords
- Allow login as root?: `No`
- Full name for the new user: you can just skip
- Username for your account: preferably in small letters (it will be more convenient, for example, `"andrey"`)
- Choose a password for the new user: Just a password
#### Configure the clock
- Set the clock using NTP?: `Yes`
- NTP server to use: Just click `Continue`
- Select your time zone: Choose your option
#### Detect disks
- Activate
#### Partition disks
- you can handle it yourself :)
#### Install the base system
- Kernel to install: `linux-image-amd64` (for example)
- Drivers to include in the initrd: `generic: include all available drivers`
#### Configure the package manager
- Scan extra installation media?: `No`
- Use a network mirror?: `Yes`
- Protocol for file downloads: `http`
- Debian archive mirror country: choose your country
- Debian archive mirror: `deb.debian.org`
- Just click `Continue`
- Use non-free firmware?: `Yes`
- Use non-free firmware?: `Yes`
- Enable source repositories in APT?: `Yes`
- Services to use: Just click `Continue`
#### Select and install software
- Updates management on this system: `No automatic updates`
- Participate in the package usage survey?: `No`
- Choose software to install: Leave everything as it is, just click `Continue`
#### Install the GRUB boot loader
- Run os-prober automatically to detect and boot other OSes?: `Yes`
- Install the GRUB boot loader to your primary drive?: `Yes`
#### Finish the installation
- Is the system clock set to UTC?: `Yes`
- Please choose `<Continue>` to reboot: `Continue`
## Automatic installation
in order not to manually install all the components, a script ([install.sh](install.sh)) was built to install each of the stages automatically. Also, don't forget to look at the #Extra Steps tab

If you do not want to install something from below, the installation of each component is scheduled in stages.
## Manual installation
### Removing applications
I left some applications from gnome, because they are more convenient than their counterparts and have functionality related to gnome itself, but I deleted some of them:
#### Update packages
```Terminal
sudo apt update -y && sudo apt upgrade -y
```
#### Remove this packages **([remove_trash.sh](scripts/apps/remove_trash.sh))**
```Terminal
#!/bin/bash
sudo apt remove -y gnome-contacts gnome-weather gnome-2048 gnome-maps aisleriot gnome-calendar gnome-chess gnome-system-monitor gnome-logs gnome-characters five-or-more four-in-a-row hitori gnome-klotski lightsoff gnome-mahjongg gnome-mines gnome-music gnome-nibbles quadrapassel rhythmbox gnome-robots shotwell gnome-sound-recorder gnome-sudoku swell-foop tali gnome-taquin gnome-tetravex seahorse iagno totem
```
### Installing applications
#### Snap installing **([snap.sh](scripts/apps/snap.sh))**
Before you start installing applications, you need to install snap, for easy installation of other applications.
```Terminal
sudo apt update -y && sudo apt upgrade -y
sudo apt install snapd -y
```
#### Required applications **([required_apps.sh](scripts/apps/required_apps.sh))**
The following applications are required to install for easy use. I decided not to stray far from the decision of the author of the [repository](https://github.com/addy-dclxvi/debian-bspwm-dotfiles) and also use the `kitty` terminal with `fish`.
```Terminal
sudo snap install btop
sudo apt install -y dconf-editor fish gnome-pie grub-customizer kitty pulseaudio curl git neofetch

# Change the default shell to fish
chsh $USER -s /usr/bin/fish
```
If your laptop is Huawei 14s/16s, you may have some sound problems. To solve this, run the fix [script](scripts/fixes/huawei_sound_fix/install.sh) (taken from [here](https://github.com/Smoren/huawei-ubuntu-sound-fix)).

I also recommend using `flameshot` instead of the standard screenshot app:
```Terminal
sudo apt remove gnome-screenshot && sudo apt install -y flameshot
```
#### Optional applications **([optional_apps.sh](scripts/apps/optional_apps.sh))**
For my tasks, I use the following minimal application stack. This installation is optional.
```Terminal
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y qbittorrent
sudo snap install pycharm-community --classic
sudo snap install intellij-idea-community --classic
sudo snap install code --classic
sudo snap install obsidian --classic
sudo snap install telegram-desktop
sudo snap install discord
sudo snap install arduino
sudo usermod -a -G dialout $USER
```
Docker **([docker.sh](scripts/apps/docker.sh))**:
```Terminal
# Add Docker's official GPG key:
sudo apt update -y
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
Yandex Music **([yandex_music.sh](scripts/apps/yandex_music.sh))**:
```Terminal
# Variables
REPO_URL="https://api.github.com/repos/cucumber-sp/yandex-music-linux/releases/latest"
TEMP_DEB="/tmp/yandex-music-linux.deb"
# Install dependencies
sudo apt-get update
sudo apt-get install -y curl jq
# Get the download URL of the latest release, filtering for .deb files that contain "amd64"
DOWNLOAD_URL=$(curl -s $REPO_URL | jq -r '.assets[] | select(.name | endswith(".deb") and contains("amd64")) | .browser_download_url')
# Check if the URL is empty
if [ -z "$DOWNLOAD_URL" ]; then
    echo "Could not find an amd64 .deb file in the latest release."
    exit 1
fi
# Download the .deb file
curl -L -o $TEMP_DEB "$DOWNLOAD_URL"
# Install the package
sudo dpkg -i $TEMP_DEB
# Fix missing dependencies if any
sudo apt-get install -f
# Remove the temporary file
rm $TEMP_DEB
```
#### Removing unnecessary packages
```Terminal
sudo apt autoremove -y
```
### Installing configs and extensions
In addition to the applications themselves, you need to install wallpapers, configs of these applications, settings and extensions with their configs.
#### Adding images **([add_images.sh](scripts/custom/add_images.sh))**
```Terminal
sudo rm ~/.face
sudo rm ~/.face.icon

cp ../../home/background2K.png ~/.background2K.png
cp ../../home/gdm_background2K.png ~/.gdm_background2K.png
```
#### Adding configs **([config.sh](scripts/custom/config.sh))**
```Terminal
sudo rm -r ~/.config
cp -r ../../config ~/.config 
```
#### Adding extensions **([set_extensions.sh](scripts/custom/set_extensions.sh))**
```Terminal
mkdir ~/.local/share/gnome-shell/extensions
cp -r ../../extensions/backup/* ~/.local/share/gnome-shell/extensions/
dconf load /org/gnome/shell/extensions/ < ../../extensions/settings_backup.txt
```
To enable them, run the following commands after restarting **([enable_extensions.sh](scripts/custom/enable_extensions.sh))**:
```
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
```
### Setting themes
To make the system look beautiful, I use [theme for the appearance](https://github.com/vinceliuice/Orchis-theme) of the desktop and a [theme for loading grub](https://github.com/adi1090x/plymouth-themes), disabling all logs and dialog boxes.
#### Orchis theme (desktop)
```Terminal
git clone https://github.com/vinceliuice/Orchis-theme
cd Orchis-theme
bash install.sh --theme green --color dark --size standard
gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Green-Dark'
gsettings set org.gnome.shell.extensions.user-theme name 'Orchis-Green-Dark'
cd ..
sudo rm -r Orchis-theme

sudo apt install -y libglib2.0-dev dconf-cli
git clone --depth=1 https://github.com/realmazharhussain/gdm-tools
cd gdm-tools
sudo bash install.sh
set-gdm-theme backup update
set-gdm-theme set -b ~/.gdm_background2K.png
cd ..
sudo rm -r gdm-tools
```
#### Plymouth theme (grub)
```Terminal
sudo rm /etc/default/grub
sudo cp grub /etc/default/
sudo update-grub

# make sure you have the packages for plymouth
sudo apt install -y plymouth

# after downloading or cloning themes, copy the selected theme in plymouth theme dir
sudo rm -r /usr/share/plymouth/themes/cubes
sudo cp -r ../../../grub-theme /usr/share/plymouth/themes/cubes

# install the new theme (angular, in this case)
sudo update-alternatives -telegram-desktop-install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/cubes/cubes.plymouth 100

# select the theme to apply
sudo plymouth-set-default-theme cubes
# update initramfs 
sudo update-initramfs -u
```
## Extra Steps
- Be careful with the automatic installation. The scripts are not perfect and maybe some will not work for you, as they may only fit my system or account. I advise you to figure out each step of the installation yourself
- After any of the installations, do not forget to change the graphics platform from wayland to Xorg, otherwise at least the gnome pie menu will not work: ![switch wayland to x11 tutorial](assets/switch-wayland-to-x11.gif)
- I noticed that some applications cannot save the result if the window is closed not through the X (cross) button, but simply by closing (for example, when old keys are rebinded. To return the window close button, enter the command: `gsettings set org.gnome.desktop.wm.preferences button-layout :close`
# Keybinds
Keybinds were made based on the names of applications or associations with them. To launch the rest of the applications, `gnome pie` or search is used (clicking on win and entering the name).
- **`Super + Enter`** Launch terminal
- **`Alt + A`** Launch Gnome Pie
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
- **`Super + Shift + {number}`** Move the window to the `{number}` workspace
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