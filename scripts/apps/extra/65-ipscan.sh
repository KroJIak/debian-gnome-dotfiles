#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

run_cmd "apt update" sudo apt update -qq
run_cmd "install default-jre" sudo apt install $APT_YES_FLAG -qq default-jre

wget -q -O /tmp/ipscan_3.9.3_amd64.deb \
  https://github.com/angryip/ipscan/releases/download/3.9.3/ipscan_3.9.3_amd64.deb

run_cmd "install ipscan" sudo apt install $APT_YES_FLAG -qq /tmp/ipscan_3.9.3_amd64.deb