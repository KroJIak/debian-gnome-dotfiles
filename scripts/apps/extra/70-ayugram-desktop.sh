#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

REPO="0FL01/AyuGramDesktop-flatpak"
API="https://api.github.com/repos/${REPO}/releases/latest"

need() {
  command -v "$1" >/dev/null 2>&1 || fail "missing dependency: $1"
}

need curl
need jq

json="$(curl -fsSL "$API")"
url="$(
  jq -r '.assets[] | select(.name | endswith(".flatpak")) | .browser_download_url' \
    <<<"$json" | head -n1
)"

if [[ -z "$url" || "$url" == "null" ]]; then
  warn "No .flatpak asset found in latest release of ${REPO}"
  warn "Tip: open https://github.com/${REPO}/releases and check Assets."
  exit 2
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

file="$tmp_dir/$(basename "$url")"

info "Downloading: $url"
if [[ "${DOTFILES_DEBUG:-0}" -eq 1 ]]; then
  curl -fL --retry 3 --retry-delay 1 -o "$file" "$url"
else
  curl -sfL --retry 3 --retry-delay 1 -o "$file" "$url"
fi
ok "Done."
info "Saved to: $file"
