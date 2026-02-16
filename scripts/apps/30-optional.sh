#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

run_cmd "apt update" sudo apt update -qq
run_cmd "apt upgrade" sudo apt upgrade $APT_YES_FLAG -qq
run_cmd "install qbittorrent" sudo apt install $APT_YES_FLAG -qq qbittorrent
run_cmd "install czkawka" sudo snap install czkawka
run_cmd "install pdfarranger" sudo apt install $APT_YES_FLAG -qq pdfarranger
run_cmd "install Obsidian" sudo snap install obsidian --classic
run_cmd "install Discord" sudo snap install discord

if [[ "${DOTFILES_AUTO_YES:-0}" -eq 1 ]]; then
	reply="y"
else
	read -r -p "Install Ayugram Desktop instead of Telegram Desktop? (y/N) " reply
fi

if [[ "$reply" =~ ^[Yy]$ ]]; then
       echo "[debug] SCRIPT_DIR: $SCRIPT_DIR"
       REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
       custom_keybinds="$REPO_ROOT/scripts/system/keybinds/keys/custom.txt"
                            if bash "$SCRIPT_DIR/extra/70-ayugram-desktop.sh"; then
                                   # Меняем бинды для telegram на Ayugram Desktop
                                   touch "$custom_keybinds"
                                   sed -i 's|"telegram" ".*" "<Super>T"|"telegram" "flatpak run com.ayugram.desktop" "<Super>T"|' "$custom_keybinds"
                            else
                                   # Проверяем, установлен ли уже Ayugram Desktop
                                   if flatpak info com.ayugram.desktop >/dev/null 2>&1; then
                                          info "Ayugram Desktop is already installed, updating keybind."
                                          touch "$custom_keybinds"
                                          sed -i 's|"telegram" ".*" "<Super>T"|"telegram" "flatpak run com.ayugram.desktop" "<Super>T"|' "$custom_keybinds"
                                   else
                                          warn "Ayugram Desktop installation failed, falling back to Telegram Desktop."
                                          run_cmd "install Telegram Desktop" sudo snap install telegram-desktop
                                          # Восстанавливаем бинды для telegram на telegram-desktop
                                          touch "$custom_keybinds"
                                          sed -i 's|"telegram" ".*" "<Super>T"|"telegram" "telegram-desktop" "<Super>T"|' "$custom_keybinds"
                                   fi
                            fi
else
       echo "[debug] SCRIPT_DIR: $SCRIPT_DIR"
       debug_path="$SCRIPT_DIR/../../system/keybinds/keys/custom.txt"
       echo "[debug] Checking existence of $debug_path"
       abs_debug_path="$(realpath "$debug_path" 2>/dev/null || echo '[realpath failed]')"
       echo "[debug] realpath: $abs_debug_path"
       ls -l "$debug_path" || echo "[debug] custom.txt not found!"
       run_cmd "install Telegram Desktop" sudo snap install telegram-desktop
       # Восстанавливаем бинды для telegram на telegram-desktop
       touch "$custom_keybinds"
       sed -i 's|"telegram" ".*" "<Super>T"|"telegram" "telegram-desktop" "<Super>T"|' "$custom_keybinds"
fi

bash "$SCRIPT_DIR/extra/40-docker.sh"
bash "$SCRIPT_DIR/extra/35-chrome.sh"
bash "$SCRIPT_DIR/extra/50-yandex-music.sh"
bash "$SCRIPT_DIR/extra/55-vscode.sh"
bash "$SCRIPT_DIR/extra/redvpn/install.sh" --quiet --skip-key
bash "$SCRIPT_DIR/extra/75-tailscale.sh"
bash "$SCRIPT_DIR/extra/80-arduino.sh"