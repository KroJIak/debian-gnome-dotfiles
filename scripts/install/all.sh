#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

bash "$SCRIPT_DIR/apps.sh"
bash "$SCRIPT_DIR/fixes.sh"
bash "$SCRIPT_DIR/system.sh"

log "Done. Please, reboot the system and don't forget to enable extensions (scripts/system/enable-extensions.sh)."
