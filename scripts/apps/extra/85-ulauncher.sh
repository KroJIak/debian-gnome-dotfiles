#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

REPO_URL="https://api.github.com/repos/Ulauncher/Ulauncher/releases/latest"
TEMP_DIR="/tmp"

run_cmd "apt update" sudo apt update -y
run_cmd "install deps" sudo apt install -y curl wget

info "Fetching latest Ulauncher release"
latest_release="$(curl -fsSL "$REPO_URL")"
version="$(echo "$latest_release" | grep -oP '"tag_name": "\K(.*)(?=")')"
deb_url="$(echo "$latest_release" | grep -o '"browser_download_url":.*_all\.deb"' | cut -d '"' -f 4)"

if [[ -z "$version" || -z "$deb_url" ]]; then
  fail "Could not resolve Ulauncher release metadata"
fi

filename="$(basename "$deb_url")"

info "Found version: $version"
info "Downloading: $filename"

run_cmd "download ulauncher" wget -O "$TEMP_DIR/$filename" "$deb_url"

info "Installing Ulauncher"
run_cmd "install ulauncher" sudo apt install -y "$TEMP_DIR/$filename"

ok "Ulauncher $version installed"
