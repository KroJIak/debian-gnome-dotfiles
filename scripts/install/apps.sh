#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

log "[Stage 1] Applications"
log "[Stage 1] Applications | Remove Gnome bloat"
bash "$REPO_ROOT/scripts/apps/00-remove-gnome-bloat.sh"
log "[Stage 1] Applications | Install snap"
bash "$REPO_ROOT/scripts/apps/10-snapd.sh"
log "[Stage 1] Applications | Install flatpak"
bash "$REPO_ROOT/scripts/apps/15-flatpak.sh"
log "[Stage 1] Applications | Install required apps"
bash "$REPO_ROOT/scripts/apps/20-required.sh"
log "[Stage 1] Applications | Install optional apps"
bash "$REPO_ROOT/scripts/apps/30-optional.sh"
log "[Stage 1] Applications | Autoremove"
sudo apt autoremove -y
log "[Stage 1] Applications | Done"
