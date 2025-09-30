#!/bin/bash

sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y gcolor3 qbittorrent
# sudo snap install pycharm-community --classic
sudo snap install intellij-idea-ultimate --classic
sudo snap install code --classic
sudo snap install obsidian --classic
# sudo snap install telegram-desktop # | Optionally install ayugram-desktop from telegram channel
sudo snap install discord
sudo snap install arduino
sudo snap install czkawka
sudo snap install pdfarranger
sudo usermod -a -G dialout $USER # Arduino