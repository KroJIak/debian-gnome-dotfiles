#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TILIX_DIR="$SCRIPT_DIR/tilix"

sudo apt install -y tilix

dconf load /com/gexperts/Tilix/ < "$TILIX_DIR/tilix.dconf"
