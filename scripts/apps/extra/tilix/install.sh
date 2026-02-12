#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TILIX_DIR="$SCRIPT_DIR"

# shellcheck source=../../../lib/common.sh
source "$SCRIPT_DIR/../../../lib/common.sh"

run_cmd "install tilix" sudo apt install $APT_YES_FLAG -qq tilix

dconf load /com/gexperts/Tilix/ < "$TILIX_DIR/tilix.dconf"
