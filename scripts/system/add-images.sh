#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

rm -f "$HOME/.face" "$HOME/.face.icon"

cp "$REPO_ROOT/home/background2K.png" "$HOME/.background2K.png"
cp "$REPO_ROOT/home/gdm_background2K.png" "$HOME/.gdm_background2K.png"