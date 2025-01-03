#!/bin/bash

mkdir $HOME/.ssh
SSH_CONFIG_FILE="$HOME/.ssh/config"

if [ ! -f "$SSH_CONFIG_FILE" ]; then
    touch "$SSH_CONFIG_FILE"
fi

echo -e "\n# HostKeyAlgorithms for all hosts" >> "$SSH_CONFIG_FILE"
echo -e "\nHost *\n    HostKeyAlgorithms +ssh-rsa" >> "$SSH_CONFIG_FILE"
