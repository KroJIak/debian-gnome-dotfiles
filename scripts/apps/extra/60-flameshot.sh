#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

run_cmd "remove gnome-screenshot" sudo apt remove $APT_YES_FLAG -qq gnome-screenshot
run_cmd "install flameshot" sudo apt install $APT_YES_FLAG -qq flameshot
