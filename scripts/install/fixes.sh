#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

log "[Stage 2] Fixes"
if [[ "${DOTFILES_SKIP_FIXES:-0}" -eq 1 ]]; then
	warn "[Stage 2] Fixes | Skipping"
	return 0
fi

FIX_ARGS=()
if [[ "${DOTFILES_DEBUG:-0}" -eq 1 ]]; then
	FIX_ARGS+=(--debug)
fi
if [[ "${DOTFILES_AUTO_YES:-0}" -eq 1 ]]; then
	FIX_ARGS+=(--yes)
fi

log "[Stage 2] Fixes | Huawei sound"
bash "$REPO_ROOT/scripts/fixes/huawei-sound/install.sh" "${FIX_ARGS[@]}"
log "[Stage 2] Fixes | Fn keys on Huawei laptops"
bash "$REPO_ROOT/scripts/fixes/fnkeys/install.sh" "${FIX_ARGS[@]}"
log "[Stage 2] Fixes | X11 fractional scaling"
bash "$REPO_ROOT/scripts/fixes/x11-fractional-scaling/install.sh" "${FIX_ARGS[@]}"
log "[Stage 2] Fixes | Done"
