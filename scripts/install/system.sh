#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

log "[Stage 3] System"
if [[ "${DOTFILES_SKIP_SYSTEM:-0}" -eq 1 ]]; then
	warn "[Stage 3] System | Skipping"
	return 0
fi
log "[Stage 3] System | Add images"
bash "$REPO_ROOT/scripts/system/add-images.sh"
log "[Stage 3] System | Apply configs"
bash "$REPO_ROOT/scripts/system/apply-configs.sh"
log "[Stage 3] System | Apply settings"
bash "$REPO_ROOT/scripts/system/apply-settings.sh"
log "[Stage 3] System | Apply extensions"
bash "$REPO_ROOT/scripts/system/apply-extensions.sh"
log "[Stage 3] System | Update SSH config"
bash "$REPO_ROOT/scripts/system/update-ssh-config.sh"
log "[Stage 3] System | Apply grub theme"
bash "$REPO_ROOT/scripts/system/grub/apply.sh"
log "[Stage 3] System | Apply desktop themes"
bash "$REPO_ROOT/scripts/system/apply-themes.sh"
log "[Stage 3] System | Enable extensions"
info "After reboot or re-login, enable extensions manually: bash $REPO_ROOT/scripts/system/enable-extensions.sh (or use GNOME Extensions in Settings)"
log "[Stage 3] System | Done"
