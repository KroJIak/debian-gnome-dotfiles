#!/usr/bin/env bash
set -euo pipefail

AUTO_YES=0
DEBUG=0

usage() {
	cat <<'EOF'
Usage: uninstall.sh [--debug] [-y|--yes]

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

info "Uninstalling Huawei sound fix"

if ! prompt_confirm "Stop and remove Huawei sound service and files?"; then
	warn "Uninstall cancelled"
	exit 0
fi

run_cmd "stop service" sudo systemctl stop huawei-soundcard-headphones-monitor.service
run_cmd "remove script" sudo rm -f /usr/local/bin/huawei-soundcard-headphones-monitor.sh
run_cmd "remove unit" sudo rm -f /etc/systemd/system/huawei-soundcard-headphones-monitor.service
run_cmd "systemctl daemon-reload" sudo systemctl daemon-reload

ok "done"