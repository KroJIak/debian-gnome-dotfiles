#!/bin/bash

echo "=== Установка темы DedSec для GRUB ==="

# Проверяем наличие Python3
if ! command -v python3 &> /dev/null; then
    echo "Установка Python3..."
    sudo apt install -y python3
fi

# Создаем временную директорию
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "Скачивание темы DedSec..."
git clone --depth 1 https://github.com/VandalByte/dedsec-grub2-theme.git

if [ $? -eq 0 ]; then
    cd dedsec-grub2-theme
    echo "Установка темы..."
    sudo python3 dedsec-theme.py --install
    
    if [ $? -eq 0 ]; then
        echo "Тема DedSec успешно установлена!"
        echo "Обновление конфигурации GRUB..."
        sudo update-grub
    else
        echo "Ошибка при установке темы"
        exit 1
    fi
else
    echo "Ошибка при скачивании темы"
    exit 1
fi

# Очищаем временные файлы
cd /
rm -rf "$TEMP_DIR"

echo "=== Установка завершена ==="
echo "Перезагрузите систему для применения темы."