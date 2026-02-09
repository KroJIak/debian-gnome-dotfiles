#!/usr/bin/env bash
set -euo pipefail

# Source: https://github.com/Smoren/huawei-ubuntu-sound-fix

AUTO_YES=0
DEBUG=0

usage() {
	cat <<'EOF'
Usage: install.sh [--debug] [-y|--yes]

	--debug   Show full command output.
	-y,--yes  Accept all prompts automatically.
EOF
}

for arg in "$@"; do
	case "$arg" in
		--debug) DEBUG=1 ;;
		-y|--yes) AUTO_YES=1 ;;
		-h|--help) usage; exit 0 ;;
		*) echo "Unknown argument: $arg" >&2; usage; exit 1 ;;
	esac
done

if command -v tput >/dev/null 2>&1; then
	COLOR_OK=$(tput setaf 2)
	COLOR_WARN=$(tput setaf 3)
	COLOR_ERR=$(tput setaf 1)
	COLOR_INFO=$(tput setaf 6)
	COLOR_DIM=$(tput setaf 7)
	COLOR_RESET=$(tput sgr0)
else
	COLOR_OK=""
	COLOR_WARN=""
	COLOR_ERR=""
	COLOR_INFO=""
	COLOR_DIM=""
	COLOR_RESET=""
fi

fail() {
	echo "${COLOR_ERR}[error]${COLOR_RESET} $*" >&2
	exit 1
}

info() {
	echo "${COLOR_INFO}[info]${COLOR_RESET} $*"
}

warn() {
	echo "${COLOR_WARN}[warn]${COLOR_RESET} $*" >&2
}

ok() {
	echo "${COLOR_OK}[ok]${COLOR_RESET} $*"
}

prompt_confirm() {
	local message="$1"
	if [[ "$AUTO_YES" -eq 1 ]]; then
		echo "${COLOR_DIM}[auto-yes]${COLOR_RESET} $message"
		return 0
	fi
	read -r -p "$message [y/N]: " reply
	[[ "$reply" == "y" || "$reply" == "Y" ]]
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${LOG_DIR:-$HOME/.cache/debian-fix-install/logs}"

run_cmd() {
	local label="$1"
	shift
	mkdir -p "$LOG_DIR"
	if [[ "$DEBUG" -eq 1 ]]; then
		info "$label"
		"$@"
	else
		local log_file
		log_file="$LOG_DIR/$(date +%Y%m%d-%H%M%S)-${label// /_}.log"
		info "$label (log: $log_file)"
		if ! "$@" >"$log_file" 2>&1; then
			warn "$label failed; see $log_file"
			tail -n 40 "$log_file" >&2 || true
			return 1
		fi
	fi
}

SERVICE_SCRIPT="$SCRIPT_DIR/huawei-soundcard-headphones-monitor.sh"
SERVICE_UNIT="$SCRIPT_DIR/huawei-soundcard-headphones-monitor.service"

[[ -f "$SERVICE_SCRIPT" ]] || fail "Missing: $SERVICE_SCRIPT"
[[ -f "$SERVICE_UNIT" ]] || fail "Missing: $SERVICE_UNIT"

info "Installing Huawei sound fix"

if prompt_confirm "Install required packages (alsa-tools, alsa-utils)?"; then
	run_cmd "apt update" sudo apt update -y
	run_cmd "install packages" sudo apt install -y alsa-tools alsa-utils
else
	warn "Skipping package installation"
fi

run_cmd "copy monitor script" sudo cp "$SERVICE_SCRIPT" /usr/local/bin/
run_cmd "copy systemd unit" sudo cp "$SERVICE_UNIT" /etc/systemd/system/
run_cmd "chmod monitor script" sudo chmod +x /usr/local/bin/huawei-soundcard-headphones-monitor.sh
run_cmd "chmod systemd unit" sudo chmod +x /etc/systemd/system/huawei-soundcard-headphones-monitor.service

run_cmd "systemctl daemon-reload" sudo systemctl daemon-reload
run_cmd "enable service" sudo systemctl enable huawei-soundcard-headphones-monitor
run_cmd "restart service" sudo systemctl restart huawei-soundcard-headphones-monitor

ok "done"