#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

DOTFILES_DEBUG=0
DOTFILES_AUTO_YES=0
DOTFILES_SKIP_OPTIONAL_APPS=0
DOTFILES_SKIP_FIXES=0
DOTFILES_SKIP_SYSTEM=0
DOTFILES_ONLY_FIXES=0
DOTFILES_ONLY_SYSTEM=0

usage() {
	cat <<'EOF'
Usage: ./install.sh [options]

Options:
	--debug               Show full command output.
	-y, --yes             Accept all prompts automatically.
	--skip-optional-apps  Skip optional apps stage.
	--skip-fixes          Skip fixes stage.
	--skip-system         Skip system stage.
	--only-fixes          Run only fixes stage.
	--only-system         Run only system stage.
	-h, --help            Show this help message.
EOF
}

for arg in "$@"; do
	case "$arg" in
		--debug) DOTFILES_DEBUG=1 ;;
		-y|--yes) DOTFILES_AUTO_YES=1 ;;
		--skip-optional-apps) DOTFILES_SKIP_OPTIONAL_APPS=1 ;;
		--skip-fixes) DOTFILES_SKIP_FIXES=1 ;;
		--skip-system) DOTFILES_SKIP_SYSTEM=1 ;;
		--only-fixes) DOTFILES_ONLY_FIXES=1 ;;
		--only-system) DOTFILES_ONLY_SYSTEM=1 ;;
		-h|--help) usage; exit 0 ;;
		*) fail "Unknown argument: $arg" ;;
	esac
done

if [[ "$DOTFILES_ONLY_FIXES" -eq 1 && "$DOTFILES_ONLY_SYSTEM" -eq 1 ]]; then
	fail "--only-fixes and --only-system cannot be used together."
fi

export DOTFILES_DEBUG
export DOTFILES_AUTO_YES
export DOTFILES_SKIP_OPTIONAL_APPS
export DOTFILES_SKIP_FIXES
export DOTFILES_SKIP_SYSTEM
export DOTFILES_ONLY_FIXES
export DOTFILES_ONLY_SYSTEM

bash "$ROOT_DIR/scripts/install/all.sh"

echo
ok "Install finished. Please reboot for all changes to take effect."
