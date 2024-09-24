
cd scripts

echo "[Stage 1] Applications"
cd apps
echo "[Stage 1] Applications | Remove Trash"
bash remove_trash.sh
echo "[Stage 1] Applications | Installing snap"
bash snap.sh
echo "[Stage 1] Applications | Installing required applications"
bash required_apps.sh
echo "[Stage 1] Applications | Installing optional applications"
bash optional_apps.sh
echo "[Stage 1] Applications | Installing anydesk"
bash anydesk.sh
echo "[Stage 1] Applications | Installing docker"
bash docker.sh
echo "[Stage 1] Applications | Installing yandex_music"
bash yandex_music.sh
echo "[Stage 1] Applications | Autoremove"
sudo apt autoremove -y
echo "[Stage 1] Applications | Done"
cd ..

echo "[Stage 2] Fixes"
cd fixes/huawei_sound_fix
echo "[Stage 2] Fixes | Huawei sound"
bash install.sh
echo "[Stage 2] Fixes | Done"
cd ../..

echo "[Stage 3] Custom scripts"
cd custom
echo "[Stage 3] Custom scripts | Adding images"
bash add_images.sh
echo "[Stage 3] Custom scripts | Insert configs"
bash config.sh
echo "[Stage 3] Custom scripts | Insert settings"
bash settings.sh
echo "[Stage 3] Custom scripts | Insert extensions"
bash set_extensions.sh
echo "[Stage 3] Custom scripts | Set grub theme"
cd grub
bash setup.sh
cd ..
echo "[Stage 3] Custom scripts | Set themes"
bash themes.sh
echo "[Stage 3] Custom scripts | Done"
cd ..
echo "Done. Please, reboot the system and don't forget to enable extensions (scripts/enable_extensions.sh)."
