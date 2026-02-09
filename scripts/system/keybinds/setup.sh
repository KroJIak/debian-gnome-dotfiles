#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CUSTOM_BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom"
CUSTOM_SCHEMA="org.gnome.settings-daemon.plugins.media-keys"

trim() {
  local s="$1"
  s="${s#${s%%[![:space:]]*}}"
  s="${s%${s##*[![:space:]]}}"
  printf '%s' "$s"
}

read_gsettings_array() {
  local raw
  raw="$(gsettings get "$CUSTOM_SCHEMA" custom-keybindings)"
  if [[ "$raw" == "@as []" ]]; then
    printf '%s' ""
    return 0
  fi

  raw="${raw#\[}"
  raw="${raw%\]}"
  raw="${raw//\'/}"

  local out=()
  IFS=',' read -ra parts <<< "$raw"
  for item in "${parts[@]}"; do
    item="$(trim "$item")"
    if [ -n "$item" ]; then
      out+=("$item")
    fi
  done

  printf '%s' "${out[*]}"
}

write_gsettings_array() {
  local -a arr=("$@")
  local out="["
  local first=1
  local item
  for item in "${arr[@]}"; do
    if [ -z "$item" ]; then
      continue
    fi
    if [ $first -eq 1 ]; then
      first=0
    else
      out+=", "
    fi
    out+="'${item}'"
  done
  out+="]"
  gsettings set "$CUSTOM_SCHEMA" custom-keybindings "$out"
}

add_unique() {
  local value="$1"
  shift
  local -a arr=("$@")
  local item
  for item in "${arr[@]}"; do
    if [ "$item" = "$value" ]; then
      printf '%s' "${arr[*]}"
      return 0
    fi
  done
  arr+=("$value")
  printf '%s' "${arr[*]}"
}

resolve_telegram_command() {
  local fallback="$1"
  if command -v telegram-desktop >/dev/null 2>&1; then
    printf '%s' "telegram-desktop"
    return 0
  fi
  if command -v ayugram-desktop >/dev/null 2>&1; then
    printf '%s' "ayugram-desktop"
    return 0
  fi
  printf '%s' "$fallback"
}

apply_custom() {
  local file="$SCRIPT_DIR/keys/custom.txt"
  local -a current
  IFS=' ' read -r -a current <<< "$(read_gsettings_array)"

  local index=0
  while IFS= read -r line || [ -n "$line" ]; do
    line="$(trim "$line")"
    if [ -z "$line" ]; then
      continue
    fi

    name="$(printf '%s\n' "$line" | awk -F'"' '{print $2}')"
    command="$(printf '%s\n' "$line" | awk -F'"' '{print $4}')"
    bind="$(printf '%s\n' "$line" | awk -F'"' '{print $6}')"

    if [ "$name" = "telegram" ]; then
      command="$(resolve_telegram_command "$command")"
    fi

    local path="${CUSTOM_BASE}${index}/"
    gsettings set "${CUSTOM_SCHEMA}.custom-keybinding:${path}" name "$name"
    gsettings set "${CUSTOM_SCHEMA}.custom-keybinding:${path}" command "$command"
    gsettings set "${CUSTOM_SCHEMA}.custom-keybinding:${path}" binding "$bind"

    IFS=' ' read -r -a current <<< "$(add_unique "$path" "${current[@]}")"
    index=$((index + 1))
  done < "$file"

  write_gsettings_array "${current[@]}"
}

apply_defaults() {
  local schema="$1"
  local file="$2"
  while IFS= read -r line || [ -n "$line" ]; do
    line="$(trim "$line")"
    if [ -z "$line" ]; then
      continue
    fi

    name="$(printf '%s\n' "$line" | awk -F'"' '{print $2}')"
    bind="$(printf '%s\n' "$line" | awk -F'"' '{print $4}')"
    if [ -n "$bind" ]; then
      gsettings set "$schema" "$name" "['$bind']"
    else
      gsettings set "$schema" "$name" "[]"
    fi
  done < "$file"
}

apply_custom
apply_defaults "org.gnome.desktop.wm.keybindings" "$SCRIPT_DIR/keys/wm.txt"
apply_defaults "org.gnome.shell.keybindings" "$SCRIPT_DIR/keys/shell.txt"
apply_defaults "org.gnome.settings-daemon.plugins.media-keys" "$SCRIPT_DIR/keys/media-keys.txt"
