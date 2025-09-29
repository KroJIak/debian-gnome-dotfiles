#!/bin/bash

# Скрипт для управления пунктами меню GRUB
# Позволяет скрывать/показывать определенные пункты меню

GRUB_CONFIG="/etc/default/grub"
BACKUP_DIR="/etc/default/grub_backups"

# Создаем директорию для бэкапов если не существует
sudo mkdir -p "$BACKUP_DIR"

# Функция для создания бэкапа
create_backup() {
    local backup_file="$BACKUP_DIR/grub.backup.$(date +%Y%m%d_%H%M%S)"
    sudo cp "$GRUB_CONFIG" "$backup_file"
    echo "Создан бэкап: $backup_file"
}

# Функция для скрытия пунктов восстановления
hide_recovery() {
    echo "Скрытие пунктов восстановления..."
    sudo sed -i 's/^#GRUB_DISABLE_RECOVERY="true"/GRUB_DISABLE_RECOVERY="true"/' "$GRUB_CONFIG"
    sudo sed -i 's/^GRUB_DISABLE_RECOVERY="false"/GRUB_DISABLE_RECOVERY="true"/' "$GRUB_CONFIG"
}

# Функция для показа пунктов восстановления
show_recovery() {
    echo "Показ пунктов восстановления..."
    sudo sed -i 's/^GRUB_DISABLE_RECOVERY="true"/#GRUB_DISABLE_RECOVERY="true"/' "$GRUB_CONFIG"
}

# Функция для изменения таймаута
set_timeout() {
    local timeout=$1
    echo "Установка таймаута: $timeout секунд..."
    sudo sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=\"$timeout\"/" "$GRUB_CONFIG"
}

# Функция для установки системы по умолчанию
set_default_os() {
    local os_name=$1
    echo "Установка системы по умолчанию: $os_name"
    sudo sed -i "s/^GRUB_DEFAULT=.*/GRUB_DEFAULT=\"$os_name\"/" "$GRUB_CONFIG"
}

# Функция для обновления GRUB
update_grub() {
    echo "Обновление конфигурации GRUB..."
    sudo update-grub
    echo "GRUB обновлен успешно!"
}

# Функция для показа текущих настроек
show_current_settings() {
    echo "=== Текущие настройки GRUB ==="
    echo "Система по умолчанию: $(grep '^GRUB_DEFAULT=' "$GRUB_CONFIG" | cut -d'"' -f2)"
    echo "Таймаут: $(grep '^GRUB_TIMEOUT=' "$GRUB_CONFIG" | cut -d'"' -f2) секунд"
    echo "Пункты восстановления: $(if grep -q '^GRUB_DISABLE_RECOVERY="true"' "$GRUB_CONFIG"; then echo "скрыты"; else echo "показаны"; fi)"
    echo "OS Prober: $(if grep -q '^GRUB_DISABLE_OS_PROBER="false"' "$GRUB_CONFIG"; then echo "включен"; else echo "отключен"; fi)"
    echo ""
    echo "Доступные операционные системы:"
    sudo grep -E "^menuentry|^submenu" /boot/grub/grub.cfg | sed 's/menuentry "//; s/" --class.*//; s/submenu "//; s/" {.*//' | sed 's/^/- /'
}

# Главное меню
show_menu() {
    echo "=== Менеджер настроек GRUB ==="
    echo "1. Показать текущие настройки"
    echo "2. Скрыть пункты восстановления"
    echo "3. Показать пункты восстановления"
    echo "4. Изменить таймаут"
    echo "5. Установить систему по умолчанию"
    echo "6. Обновить GRUB"
    echo "7. Создать бэкап настроек"
    echo "8. Выход"
    echo ""
}

# Основной цикл
while true; do
    show_menu
    read -p "Выберите опцию (1-8): " choice
    
    case $choice in
        1)
            show_current_settings
            ;;
        2)
            create_backup
            hide_recovery
            update_grub
            ;;
        3)
            create_backup
            show_recovery
            update_grub
            ;;
        4)
            read -p "Введите новый таймаут (в секундах): " timeout
            if [[ "$timeout" =~ ^[0-9]+$ ]]; then
                create_backup
                set_timeout "$timeout"
                update_grub
            else
                echo "Ошибка: введите корректное число"
            fi
            ;;
        5)
            echo "Доступные системы:"
            sudo grep -E "^menuentry" /boot/grub/grub.cfg | sed 's/menuentry "//; s/" --class.*//' | nl
            read -p "Введите номер системы или название: " os_choice
            create_backup
            set_default_os "$os_choice"
            update_grub
            ;;
        6)
            update_grub
            ;;
        7)
            create_backup
            ;;
        8)
            echo "Выход..."
            exit 0
            ;;
        *)
            echo "Неверный выбор. Попробуйте снова."
            ;;
    esac
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
    clear
done
