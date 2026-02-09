#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

mkdir -p "$HOME/.ssh"
SSH_CONFIG_FILE="$HOME/.ssh/config"

if [ -d "$SSH_CONFIG_FILE" ]; then
    fail "$SSH_CONFIG_FILE is a directory."
fi

created=0
if [ ! -e "$SSH_CONFIG_FILE" ]; then
    touch "$SSH_CONFIG_FILE"
    created=1
fi

if [ $created -eq 1 ]; then
    chmod 600 "$SSH_CONFIG_FILE"
fi

if ! grep -qF "HostKeyAlgorithms +ssh-rsa" "$SSH_CONFIG_FILE"; then
    {
        echo
        echo "# HostKeyAlgorithms for all hosts"
        echo "Host *"
        echo "    HostKeyAlgorithms +ssh-rsa"
    } >> "$SSH_CONFIG_FILE"
fi
