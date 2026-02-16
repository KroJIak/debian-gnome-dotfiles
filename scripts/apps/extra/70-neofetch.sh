#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

REPO_URL="https://github.com/dylanaraps/neofetch.git"
TMP_DIR="$SCRIPT_DIR/neofetch-tmp"

# Clone repo
rm -rf "$TMP_DIR"
info "[neofetch] Клонируем репозиторий..."
git clone "$REPO_URL" "$TMP_DIR" || fail "[neofetch] Ошибка клонирования"
cd "$TMP_DIR"

# Install
info "[neofetch] Устанавливаем..."
sudo make install || fail "[neofetch] Ошибка установки"

# Run neofetch
info "[neofetch] Запускаем neofetch..."
neofetch || warn "[neofetch] Не удалось запустить neofetch"

# Cleanup
cd "$SCRIPT_DIR"
rm -rf "$TMP_DIR"

info "[neofetch] Удаляем временную папку..."
ok "Neofetch установлен и проверен."
