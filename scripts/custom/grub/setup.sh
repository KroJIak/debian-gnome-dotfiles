
sudo rm /etc/default/grub
sudo cp grub /etc/default/
sudo update-grub

# make sure you have the packages for plymouth
sudo apt install plymouth

# after downloading or cloning themes, copy the selected theme in plymouth theme dir
sudo cp -r ../../grub-theme /usr/share/plymouth/themes/cubes

# install the new theme (angular, in this case)
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/cubes/cubes.plymouth 100

# select the theme to apply
sudo update-alternatives --config default.plymouth
#(select the number for installed theme, angular in this case)

# update initramfs 
sudo update-initramfs -u