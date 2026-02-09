#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

if [[ "${DOTFILES_ONLY_FIXES:-0}" -eq 1 ]]; then
	bash "$SCRIPT_DIR/fixes.sh"
elif [[ "${DOTFILES_ONLY_SYSTEM:-0}" -eq 1 ]]; then
	bash "$SCRIPT_DIR/system.sh"
else
	bash "$SCRIPT_DIR/apps.sh"
	bash "$SCRIPT_DIR/fixes.sh"
	bash "$SCRIPT_DIR/system.sh"
fi

ok "Done. Please reboot for changes to take effect."
