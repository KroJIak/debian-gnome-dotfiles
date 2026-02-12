#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

run_cmd "apt update" sudo apt update -qq
run_cmd "install flatpak" sudo apt install $APT_YES_FLAG -qq flatpak
