#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

run_cmd "install VSCode" sudo snap install code --classic

extensions=(


warn "VSCode extension installation is blocked in Russia. Network access may fail."
if prompt_confirm "Do you want to try installing VSCode extensions now? (y/N)"; then
  if ! timeout 300 bash "$SCRIPT_DIR/56-vscode-extensions.sh"; then
    warn "VSCode extension installation timed out. Skipping."
  fi
else
  log "You can later install extensions with: bash scripts/apps/extra/56-vscode-extensions.sh"
fi
