#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y qbittorrent
sudo snap install pycharm-community --classic
sudo snap install intellij-idea-community --classic
sudo snap install code --classic
sudo snap install obsidian --classic
sudo snap install telegram-desktop
sudo snap install discord
sudo snap install arduino
sudo usermod -a -G dialout $USER