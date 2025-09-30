#!/bin/bash

# =============================================================================
# Debian GNOME Dotfiles - Красивый установщик
# =============================================================================

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Символы для прогресс-бара
BAR_CHAR="█"
EMPTY_CHAR="░"
BAR_WIDTH=50

# Переменные для отслеживания прогресса
TOTAL_STEPS=0
CURRENT_STEP=0

# Функция для очистки экрана
clear_screen() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${WHITE}                    Debian GNOME Dotfiles Installer                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${WHITE}                         Красивый установщик                          ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Функция для отображения прогресс-бара
show_progress() {
    local current=$1
    local total=$2
    local step_name="$3"
    
    local percentage=$((current * 100 / total))
    local filled=$((current * BAR_WIDTH / total))
    local empty=$((BAR_WIDTH - filled))
    
    # Создаем строку прогресс-бара
    local bar=""
    for ((i=0; i<filled; i++)); do
        bar+="${GREEN}${BAR_CHAR}${NC}"
    done
    for ((i=0; i<empty; i++)); do
        bar+="${YELLOW}${EMPTY_CHAR}${NC}"
    done
    
    # Очищаем строку и выводим прогресс
    printf "\r${BLUE}[%3d%%]${NC} ${bar} ${WHITE}%s${NC}" "$percentage" "$step_name"
    
    if [ "$current" -eq "$total" ]; then
        echo ""
    fi
}

# Функция для выполнения команды с прогрессом
execute_step() {
    local step_name="$1"
    local script_path="$2"
    local description="$3"
    
    CURRENT_STEP=$((CURRENT_STEP + 1))
    
    # Показываем прогресс
    show_progress "$CURRENT_STEP" "$TOTAL_STEPS" "$step_name"
    
    # Выполняем скрипт (перенаправляем вывод в /dev/null для чистоты)
    if [ -f "$script_path" ]; then
        bash "$script_path" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "  ${GREEN}✓${NC} $description"
        else
            echo -e "  ${RED}✗${NC} Ошибка в $description"
        fi
    else
        echo -e "  ${RED}✗${NC} Файл не найден: $script_path"
    fi
    
    # Небольшая пауза для визуального эффекта
    sleep 0.1
}

# Функция для отображения заголовка этапа
show_stage_header() {
    local stage_num="$1"
    local stage_name="$2"
    local stage_desc="$3"
    
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${WHITE}  Этап $stage_num: $stage_name${PURPLE}                                                           ║${NC}"
    echo -e "${PURPLE}║${CYAN}  $stage_desc${PURPLE}                                                           ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Функция для отображения финального сообщения
show_completion() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${WHITE}                           УСТАНОВКА ЗАВЕРШЕНА!                        ${GREEN}║${NC}"
    echo -e "${GREEN}║${CYAN}                                                                      ${GREEN}║${NC}"
    echo -e "${GREEN}║${YELLOW}  📋 Что было установлено:${NC}                                           ${GREEN}║${NC}"
    echo -e "${GREEN}║${WHITE}     • Приложения и пакеты${NC}                                            ${GREEN}║${NC}"
    echo -e "${GREEN}║${WHITE}     • Исправления системы${NC}                                            ${GREEN}║${NC}"
    echo -e "${GREEN}║${WHITE}     • Конфигурации и настройки${NC}                                        ${GREEN}║${NC}"
    echo -e "${GREEN}║${WHITE}     • Темы и расширения GNOME${NC}                                         ${GREEN}║${NC}"
    echo -e "${GREEN}║${WHITE}     • GRUB и Plymouth${NC}                                                ${GREEN}║${NC}"
    echo -e "${GREEN}║${CYAN}                                                                      ${GREEN}║${NC}"
    echo -e "${GREEN}║${YELLOW}  🔄 Следующие шаги:${NC}                                                ${GREEN}║${NC}"
    echo -e "${GREEN}║${WHITE}     1. Перезагрузите систему${NC}                                          ${GREEN}║${NC}"
    echo -e "${GREEN}║${WHITE}     2. Включите расширения: ./scripts/custom/enable_extensions.sh${NC}      ${GREEN}║${NC}"
    echo -e "${GREEN}║${WHITE}     3. Настройте масштабирование: ./scripts/custom/display_settings.sh${NC}  ${GREEN}║${NC}"
    echo -e "${GREEN}║${CYAN}                                                                      ${GREEN}║${NC}"
    echo -e "${GREEN}║${BLUE}  💡 Совет: Проверьте README.md для дополнительной информации${NC}          ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Основная функция
main() {
    # Очищаем экран
    clear_screen
    
    # Подсчитываем общее количество шагов
    TOTAL_STEPS=0
    
    # Этап 1: Приложения
    TOTAL_STEPS=$((TOTAL_STEPS + 6)) # remove_trash, snap, required_apps, optional_apps, docker, yandex_music
    
    # Этап 2: Исправления
    TOTAL_STEPS=$((TOTAL_STEPS + 1)) # huawei_sound_fix
    
    # Этап 3: Кастомные скрипты
    TOTAL_STEPS=$((TOTAL_STEPS + 7)) # add_images, config, settings, set_extensions, update_ssh_config, grub, themes
    
    echo -e "${CYAN}Начинаем установку...${NC}"
    echo -e "${YELLOW}Всего шагов: $TOTAL_STEPS${NC}"
    echo ""
    
    # Этап 1: Приложения
    show_stage_header "1" "Приложения" "Установка необходимых и дополнительных приложений"
    
    cd scripts/apps
    execute_step "Очистка системы" "remove_trash.sh" "Удаление ненужных пакетов"
    execute_step "Snap" "snap.sh" "Установка Snap пакетов"
    execute_step "Основные приложения" "required_apps.sh" "Установка обязательных приложений"
    execute_step "Дополнительные приложения" "optional_apps.sh" "Установка дополнительных приложений"
    execute_step "Docker" "docker.sh" "Установка Docker"
    execute_step "Yandex Music" "yandex_music.sh" "Установка Yandex Music"
    
    # Автоудаление
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress "$CURRENT_STEP" "$TOTAL_STEPS" "Автоудаление"
    sudo apt autoremove -y > /dev/null 2>&1
    echo -e "  ${GREEN}✓${NC} Автоматическое удаление ненужных пакетов"
    
    cd ../..
    
    # Этап 2: Исправления
    show_stage_header "2" "Исправления" "Применение исправлений для системы"
    
    cd scripts/fixes/huawei_sound_fix
    execute_step "Huawei Sound Fix" "install.sh" "Исправление звука для Huawei"
    cd ../../..
    
    # Этап 3: Кастомные скрипты
    show_stage_header "3" "Настройки" "Применение конфигураций и настроек"
    
    cd scripts/custom
    execute_step "Изображения" "add_images.sh" "Добавление фоновых изображений"
    execute_step "Конфигурации" "config.sh" "Копирование конфигурационных файлов"
    execute_step "Настройки системы" "settings.sh" "Применение системных настроек"
    execute_step "Расширения" "set_extensions.sh" "Настройка расширений GNOME"
    execute_step "SSH конфигурация" "update_ssh_config.sh" "Обновление SSH настроек"
    
    # GRUB настройка
    cd grub
    execute_step "GRUB тема" "setup.sh" "Установка темы GRUB и Plymouth"
    cd ..
    
    execute_step "Темы" "themes.sh" "Применение тем оформления"
    cd ../..
    
    # Показываем завершение
    show_completion
}

# Проверяем, что скрипт запущен из корневой директории проекта
if [ ! -f "README.md" ] || [ ! -d "scripts" ]; then
    echo -e "${RED}Ошибка: Запустите скрипт из корневой директории проекта${NC}"
    exit 1
fi

# Запускаем основную функцию
main "$@"