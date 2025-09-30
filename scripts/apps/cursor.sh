#!/bin/bash

# Определяем архитектуру системы
ARCH=$(dpkg --print-architecture)

# URL для скачивания в зависимости от архитектуры
if [ "$ARCH" = "amd64" ]; then
    DOWNLOAD_URL="https://api2.cursor.sh/updates/download/golden/linux-x64-deb/cursor/"
    DEB_FILE="cursor-amd64.deb"
elif [ "$ARCH" = "arm64" ]; then
    DOWNLOAD_URL="https://api2.cursor.sh/updates/download/golden/linux-arm64-deb/cursor/"
    DEB_FILE="cursor-arm64.deb"
else
    echo "Неподдерживаемая архитектура: $ARCH"
    echo "Поддерживаются только amd64 и arm64"
    exit 1
fi

echo "Установка Cursor для архитектуры: $ARCH"
echo "Скачивание с: $DOWNLOAD_URL"

# Скачиваем .deb файл
wget -O "$DEB_FILE" "$DOWNLOAD_URL"

# Проверяем успешность скачивания
if [ $? -eq 0 ]; then
    echo "Файл успешно скачан: $DEB_FILE"
    
    # Устанавливаем .deb файл
    sudo dpkg -i "$DEB_FILE"
    
    # Исправляем возможные зависимости
    sudo apt-get install -f -y
    
    # Удаляем скачанный файл
    rm "$DEB_FILE"
    
    echo "Cursor успешно установлен!"
else
    echo "Ошибка при скачивании файла"
    exit 1
fi
