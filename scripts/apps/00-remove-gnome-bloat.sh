#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

run_cmd "apt update" sudo apt update -qq
run_cmd "apt upgrade" sudo apt upgrade $APT_YES_FLAG -qq
run_cmd "remove gnome bloat" sudo apt remove $APT_YES_FLAG \
	gnome-contacts gnome-weather gnome-2048 gnome-maps aisleriot \
	gnome-calendar gnome-chess gnome-system-monitor gnome-logs \
	gnome-characters five-or-more four-in-a-row hitori gnome-klotski \
	lightsoff gnome-mahjongg gnome-mines gnome-music gnome-nibbles \
	quadrapassel rhythmbox gnome-robots shotwell gnome-sound-recorder \
	gnome-sudoku swell-foop tali gnome-taquin gnome-tetravex seahorse \
	iagno totem