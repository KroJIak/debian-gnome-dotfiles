#!/usr/bin/env bash
set -euo pipefail

COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$COMMON_DIR/../.." && pwd)"

DOTFILES_DEBUG="${DOTFILES_DEBUG:-0}"
DOTFILES_AUTO_YES="${DOTFILES_AUTO_YES:-0}"
DOTFILES_LOG_DIR="${DOTFILES_LOG_DIR:-$HOME/.cache/debian-dotfiles/logs}"

# Set APT_YES_FLAG based on DOTFILES_AUTO_YES
if [[ "$DOTFILES_AUTO_YES" -eq 1 ]]; then
  APT_YES_FLAG="-y"
else
  APT_YES_FLAG=""
fi

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

log() {
  info "$@"
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

fail() {
  echo "${COLOR_ERR}[error]${COLOR_RESET} $*" >&2
  exit 1
}

prompt_confirm() {
  local message="$1"
  # Удаляем любые скобки и мусор из message
  message="$(echo "$message" | sed 's/([^)]+)//g' | sed 's/\[[^]]*\]//g')"
  if [[ "$DOTFILES_AUTO_YES" -eq 1 ]]; then
    echo "${COLOR_DIM}[auto-yes]${COLOR_RESET} $message"
    return 0
  fi
  read -r -p "$message [y/N]: " reply
  [[ "$reply" == "y" || "$reply" == "Y" ]]
}

run_cmd() {
  local label="$1"
  shift
  mkdir -p "$DOTFILES_LOG_DIR"
  if [[ "$DOTFILES_DEBUG" -eq 1 ]]; then
    info "$label"
    "$@"
  else
    local log_file
    log_file="$DOTFILES_LOG_DIR/$(date +%Y%m%d-%H%M%S)-${label// /_}.log"
    info "$label"
    if ! "$@" >"$log_file" 2>&1; then
      warn "$label failed; see $log_file"
      tail -n 40 "$log_file" >&2 || true
      return 1
    fi
  fi
}
