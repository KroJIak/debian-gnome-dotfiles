#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

# Add Docker's official GPG key:
sudo apt update -y
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y

sudo apt install -y \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

if prompt_confirm "Configure Docker registry mirrors?"; then
  warn "In Russia after 2024, Docker Hub may be unavailable for pulls."
  sudo mkdir -p /etc/docker
  sudo tee /etc/docker/daemon.json >/dev/null <<'JSON'
{
  "registry-mirrors": [
    "https://dockerhub.firstvds.ru",
    "https://dockerhub.timeweb.cloud",
    "https://docker.mirror.bepsvpt.me"
  ]
}
JSON
  sudo systemctl restart docker
fi