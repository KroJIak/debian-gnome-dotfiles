#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

if ! grep -q "tailscale" "$REPO_ROOT/extensions/settings_backup.txt"; then
	warn "tailscale commands are missing from extensions/settings_backup.txt."
fi

run_cmd "install tailscale" bash -c 'curl -fsSL https://tailscale.com/install.sh | sh'

sudo systemctl enable --now tailscaled

sudo mkdir -p /etc/systemd/system/tailscaled.service.d
sudo tee /etc/systemd/system/tailscaled.service.d/override.conf >/dev/null <<'EOF'
[Service]
ExecStartPost=/usr/bin/tailscale down
EOF

sudo systemctl daemon-reload
sudo systemctl restart tailscaled
