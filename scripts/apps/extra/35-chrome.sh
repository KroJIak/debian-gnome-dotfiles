#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_cmd() {
  echo "$1"
  shift
  "$@"
}

run_cmd "apt update" sudo apt update -qq
run_cmd "install wget and apt-transport-https" sudo apt install -y wget apt-transport-https


# Check if Google Chrome is already installed
if command -v google-chrome >/dev/null 2>&1 || command -v google-chrome-stable >/dev/null 2>&1; then
  echo "Google Chrome is already installed. Skipping download and install."
else
  CHROME_DEB="google-chrome-stable_current_amd64.deb"
  run_cmd "Download Chrome .deb" wget -q https://dl.google.com/linux/direct/$CHROME_DEB
  run_cmd "Install Chrome" sudo apt install -y ./$CHROME_DEB
  rm -f "$CHROME_DEB"
  echo "Google Chrome installed successfully."
fi
