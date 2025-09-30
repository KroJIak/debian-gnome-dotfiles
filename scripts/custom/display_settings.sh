#!/bin/bash

# Скрипт для автоматической настройки масштабирования и системных звуков
# Автоматически определяет разрешение экрана и устанавливает соответствующий масштаб

echo "=== Настройка масштабирования и системных звуков ==="

# Функция для определения разрешения экрана
get_screen_resolution() {
    # Получаем разрешение основного монитора
    local resolution=$(xrandr --query | grep "connected primary" | grep -o '[0-9]*x[0-9]*' | head -1)
    echo "$resolution"
}

# Функция для определения ширины экрана
get_screen_width() {
    local resolution=$(get_screen_resolution)
    local width=$(echo "$resolution" | cut -d'x' -f1)
    echo "$width"
}

# Функция для установки масштабирования
set_scaling() {
    local width=$1
    local scale_factor="1.0"
    
    if [ "$width" -ge 2560 ]; then
        # 2K и выше (2560px+) - масштаб 125%
        scale_factor="1.25"
        echo "Обнаружен экран 2K+ (${width}px) - устанавливаем масштаб 125%"
    else
        # FullHD и ниже (до 2560px) - масштаб 100%
        scale_factor="1.0"
        echo "Обнаружен экран FullHD (${width}px) - устанавливаем масштаб 100%"
    fi
    
    # Применяем масштабирование
    gsettings set org.gnome.desktop.interface text-scaling-factor "$scale_factor"
    echo "Масштабирование установлено: $scale_factor"
}

# Функция для отключения системных звуков
disable_system_sounds() {
    echo "Отключение системных звуков..."
    
    # Отключаем звуки событий
    gsettings set org.gnome.desktop.sound event-sounds false
    
    # Отключаем звуки ввода
    gsettings set org.gnome.desktop.sound input-feedback-sounds false
    
    # Отключаем звуки приложения
    gsettings set org.gnome.desktop.sound theme-name ""
    
    echo "Системные звуки отключены"
}

# Функция для показа текущих настроек
show_current_settings() {
    echo "=== Текущие настройки ==="
    local resolution=$(get_screen_resolution)
    local width=$(get_screen_width)
    local current_scale=$(gsettings get org.gnome.desktop.interface text-scaling-factor)
    local event_sounds=$(gsettings get org.gnome.desktop.sound event-sounds)
    local input_sounds=$(gsettings get org.gnome.desktop.sound input-feedback-sounds)
    
    echo "Разрешение экрана: $resolution"
    echo "Ширина экрана: ${width}px"
    echo "Текущий масштаб: $current_scale"
    echo "Звуки событий: $event_sounds"
    echo "Звуки ввода: $input_sounds"
    echo ""
}

# Основная логика
main() {
    echo "Определение разрешения экрана..."
    local width=$(get_screen_width)
    
    if [ -z "$width" ] || [ "$width" -eq 0 ]; then
        echo "Ошибка: не удалось определить разрешение экрана"
        exit 1
    fi
    
    echo "Обнаружено разрешение: $(get_screen_resolution)"
    
    # Показываем текущие настройки
    show_current_settings
    
    # Устанавливаем масштабирование
    set_scaling "$width"
    
    # Отключаем системные звуки
    disable_system_sounds
    
    echo ""
    echo "=== Настройка завершена ==="
    echo "Рекомендуется перезагрузить GNOME Shell для полного применения изменений:"
    echo "Нажмите Alt+F2, введите 'r' и нажмите Enter"
}

# Запуск основной функции
main "$@"


