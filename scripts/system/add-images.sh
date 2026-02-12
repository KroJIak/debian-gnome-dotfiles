#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

rm -f "$HOME/.face" "$HOME/.face.icon"

if [ -f "$REPO_ROOT/home/background2K.png" ]; then
	cp "$REPO_ROOT/home/background2K.png" "$HOME/.background2K.png"
else
	warn "background2K.png not found, skipping"
fi