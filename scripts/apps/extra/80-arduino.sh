#!/usr/bin/env bash
set -euo pipefail

sudo snap install arduino
sudo usermod -a -G dialout "$USER"