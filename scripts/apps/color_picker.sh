#!/bin/bash

# Скрипт для установки gcolor3 (color picker) через deb пакет
# gcolor3 - Simple GTK3 color selector and picker

echo "=== Установка gcolor3 (Color Picker) ==="

# Проверяем, установлен ли уже gcolor3
if command -v gcolor3 &> /dev/null; then
    echo "gcolor3 уже установлен:"
    gcolor3 --version 2>/dev/null || echo "Версия: $(dpkg -l gcolor3 | grep gcolor3 | awk '{print $3}')"
    echo ""
    echo "Для запуска используйте команду: gcolor3"
    exit 0
fi

echo "Информация о пакете gcolor3:"
echo "- Название: gcolor3"
echo "- Описание: Simple GTK3 color selector and picker"
echo "- Размер: ~78 KB"
echo "- Версия: 2.4.0-2+b1"
echo "- Репозиторий: Debian main"
echo ""

# Обновляем список пакетов
echo "Обновление списка пакетов..."
sudo apt update

# Устанавливаем gcolor3
echo "Установка gcolor3..."
sudo apt install -y gcolor3

# Проверяем успешность установки
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ gcolor3 успешно установлен!"
    echo ""
    echo "=== Информация об установке ==="
    echo "Команда для запуска: gcolor3"
    echo "Описание: Простой селектор цветов GTK3"
    echo "Функции:"
    echo "  - Быстрый выбор цветов"
    echo "  - Сохранение и удаление цветов"
    echo "  - Простой интерфейс"
    echo ""
    echo "=== Альтернативные color picker приложения ==="
    echo "Если нужны дополнительные возможности:"
    echo "  - gpick: sudo apt install gpick"
    echo "  - kcolorchooser: sudo apt install kcolorchooser"
    echo "  - gcolor2: sudo apt install gcolor2"
    echo ""
    echo "Для запуска gcolor3 выполните: gcolor3"
else
    echo "❌ Ошибка при установке gcolor3"
    exit 1
fi
