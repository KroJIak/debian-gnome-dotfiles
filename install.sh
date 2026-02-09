#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$ROOT_DIR/scripts/install/all.sh"

echo
echo "Install finished. Please reboot for all changes to take effect."
