#!/bin/bash

echo "=== Настройка GRUB и Plymouth ==="

# Создаем резервную копию текущих настроек
echo "Создание резервной копии текущих настроек GRUB..."
sudo cp /etc/default/grub /etc/default/grub.backup.$(date +%Y%m%d_%H%M%S)

# Копируем новые настройки GRUB
echo "Применение новых настроек GRUB..."
sudo cp grub /etc/default/grub

# Обновляем конфигурацию GRUB
echo "Обновление конфигурации GRUB..."
sudo update-grub

# Устанавливаем необходимые пакеты для Plymouth
echo "Установка пакетов Plymouth..."
sudo apt install -y plymouth plymouth-themes

# Настройка темы Plymouth
echo "Настройка темы Plymouth..."
# Удаляем старую тему если существует
sudo rm -rf /usr/share/plymouth/themes/cubes

# Копируем новую тему
sudo cp -r ../../../grub-theme /usr/share/plymouth/themes/cubes

# Устанавливаем тему как альтернативу
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/cubes/cubes.plymouth 100

# Применяем тему
sudo plymouth-set-default-theme cubes

# Обновляем initramfs
echo "Обновление initramfs..."
sudo update-initramfs -u

echo "=== Настройка завершена ==="
echo "Доступные операционные системы в GRUB:"
echo "- Debian (по умолчанию)"
echo "- Windows"
echo "- Ubuntu"
echo "- UEFI Settings"
echo ""
echo "Для применения изменений перезагрузите систему."