# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Отключаем oh-my-zsh тему

# ПЛАГИНЫ ДО source oh-my-zsh.sh!
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias wireshark='sudo -u root /usr/bin/wireshark'


# Starship ПОСЛЕ oh-my-zsh
eval "$(starship init zsh)"
