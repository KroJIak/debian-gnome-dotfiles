#!/usr/bin/env bash
set -euo pipefail

REPO="0FL01/AyuGramDesktop-flatpak"
API="https://api.github.com/repos/${REPO}/releases/latest"

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "missing dependency: $1" >&2; exit 1; }
}

need curl
need jq

json="$(curl -fsSL "$API")"
url="$(
  jq -r '.assets[] | select(.name | endswith(".flatpak")) | .browser_download_url' \
    <<<"$json" | head -n1
)"

if [[ -z "$url" || "$url" == "null" ]]; then
  echo "No .flatpak asset found in latest release of ${REPO}" >&2
  echo "Tip: open https://github.com/${REPO}/releases and check Assets." >&2
  exit 2
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

file="$tmp_dir/$(basename "$url")"

echo "Downloading: $url"
curl -fL --retry 3 --retry-delay 1 -o "$file" "$url"
echo "Done."
echo "Saved to: $file"
