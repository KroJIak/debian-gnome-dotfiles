#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

# Variables
REPO_URL="https://api.github.com/repos/cucumber-sp/yandex-music-linux/releases/latest"
TEMP_DEB="/tmp/yandex-music-linux.deb"

# Install dependencies
run_cmd "apt update" sudo apt-get update -qq
run_cmd "install curl jq" sudo apt-get install $APT_YES_FLAG -qq curl jq

# Get the download URL of the latest release, filtering for .deb files that contain "amd64"
DOWNLOAD_URL=$(curl -s "$REPO_URL" | jq -r \
    '.assets[] | select(.name | endswith(".deb") and contains("amd64")) | .browser_download_url')

# Check if the URL is empty
if [ -z "$DOWNLOAD_URL" ]; then
    fail "Could not find an amd64 .deb file in the latest release."
fi

# Download the .deb file
info "Downloading Yandex Music..."
curl -sL -o "$TEMP_DEB" "$DOWNLOAD_URL"

# Install the package
sudo dpkg -i "$TEMP_DEB"

# Fix missing dependencies if any
run_cmd "fix dependencies" sudo apt-get install $APT_YES_FLAG -f -qq

# Remove the temporary file
rm "$TEMP_DEB"