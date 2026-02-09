#!/usr/bin/env bash
set -euo pipefail

# Source: https://github.com/Smoren/huawei-ubuntu-sound-fix

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo apt update -y
sudo apt install -y alsa-tools alsa-utils

sudo cp "$SCRIPT_DIR/huawei-soundcard-headphones-monitor.sh" /usr/local/bin/
sudo cp "$SCRIPT_DIR/huawei-soundcard-headphones-monitor.service" /etc/systemd/system/

sudo chmod +x /usr/local/bin/huawei-soundcard-headphones-monitor.sh
sudo chmod +x /etc/systemd/system/huawei-soundcard-headphones-monitor.service

sudo systemctl daemon-reload
sudo systemctl enable huawei-soundcard-headphones-monitor
sudo systemctl restart huawei-soundcard-headphones-monitor