#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_DIR="$SCRIPT_DIR/zsh"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
FONT_DIR="$HOME/.local/share/fonts/FiraCodeNerdFont"

sudo apt install -y zsh git curl unzip

if ! command -v starship >/dev/null 2>&1; then
	curl -fsSL https://starship.rs/install.sh | sh -s -- -y
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
	RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

cp "$ZSH_DIR/.zshrc" "$HOME/.zshrc"

if ! fc-list | grep -qi "FiraCode Nerd Font"; then
	mkdir -p "$FONT_DIR"
	font_zip="$(mktemp)"
	curl -fsSL "$FONT_URL" -o "$font_zip"
	unzip -o "$font_zip" -d "$FONT_DIR" >/dev/null
	rm -f "$font_zip"
	fc-cache -f "$FONT_DIR" >/dev/null
fi
