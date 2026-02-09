#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

sudo rm /etc/default/grub
sudo cp "$SCRIPT_DIR/grub" /etc/default/
sudo update-grub