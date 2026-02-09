#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.ssh"
SSH_CONFIG_FILE="$HOME/.ssh/config"

if [ ! -f "$SSH_CONFIG_FILE" ]; then
    touch "$SSH_CONFIG_FILE"
fi

if ! grep -q "HostKeyAlgorithms +ssh-rsa" "$SSH_CONFIG_FILE"; then
    {
        echo
        echo "# HostKeyAlgorithms for all hosts"
        echo "Host *"
        echo "    HostKeyAlgorithms +ssh-rsa"
    } >> "$SSH_CONFIG_FILE"
fi
