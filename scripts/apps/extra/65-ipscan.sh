#!/usr/bin/env bash
set -euo pipefail

sudo apt update -y
sudo apt install -y default-jre

wget -O /tmp/ipscan_3.9.3_amd64.deb \
  https://github.com/angryip/ipscan/releases/download/3.9.3/ipscan_3.9.3_amd64.deb

sudo apt install -y /tmp/ipscan_3.9.3_amd64.deb