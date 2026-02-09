#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

log "[Stage 2] Fixes"
log "[Stage 2] Fixes | Huawei sound"
bash "$REPO_ROOT/scripts/fixes/huawei-sound/install.sh"
log "[Stage 2] Fixes | Done"
