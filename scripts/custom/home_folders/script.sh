#!/bin/bash

rm -r ~/Desktop
rm -r ~/Music
rm -r ~/Pictures
rm -r ~/Public
rm -r ~/Templates
rm -r ~/Videos
mkdir ~/Media

mv user-dirs.dirs ~/.config/user-dirs.dirs
mv user-dirs.locale ~/.config/user-dirs.locale

xdg-user-dirs-update