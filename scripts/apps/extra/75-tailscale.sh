#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

if ! grep -q "tailscale" "$REPO_ROOT/extensions/settings_backup.txt"; then
	echo "Warning: tailscale commands are missing from extensions/settings_backup.txt." >&2
fi

curl -fsSL https://tailscale.com/install.sh | sh

sudo systemctl enable --now tailscaled

sudo mkdir -p /etc/systemd/system/tailscaled.service.d
sudo tee /etc/systemd/system/tailscaled.service.d/override.conf >/dev/null <<'EOF'
[Service]
ExecStartPost=/usr/bin/tailscale down
EOF

sudo systemctl daemon-reload
sudo systemctl restart tailscaled
