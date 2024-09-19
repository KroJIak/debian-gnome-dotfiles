#!/bin/bash

# Путь к файлу с ключевыми привязками
keybinds_file="keybinds.txt"

# Путь к списку текущих привязок
keybindings_path="org.gnome.settings-daemon.plugins.media-keys custom-keybindings"

# Получаем текущий список кастомных привязок
current_keybindings=$(gsettings get $keybindings_path)

# Если привязки пусты, инициализируем их пустым массивом
if [ "$current_keybindings" == "@as []" ]; then
    current_keybindings="[]"
fi

# Счетчик привязок для создания уникальных путей
count=$(echo $current_keybindings | grep -o "custom" | wc -l)

# Функция для добавления новой привязки в список
add_keybinding() {
    local name="$1"
    local command="$2"
    local binding="$3"

    # Создаем уникальный путь для новой привязки
    custom_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$count/"
    
    # Добавляем привязку в список
    current_keybindings=$(echo $current_keybindings | sed "s/]$/, '$custom_path']/")

    # Устанавливаем команду, имя и привязку клавиш
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$custom_path name "$name"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$custom_path command "$command"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$custom_path binding "$binding"

    # Инкрементируем счетчик для следующей привязки
    ((count++))
}

# Чтение файла с привязками
while IFS= read -r line; do
    # Извлекаем данные из строки
    name=$(echo $line | cut -d'"' -f2)
    command=$(echo $line | cut -d'"' -f4)
    bind=$(echo $line | cut -d'"' -f6)

    # Добавляем привязку
    add_keybinding "$name" "$command" "$bind"
done < "$keybinds_file"

# Устанавливаем обновленный список привязок
gsettings set $keybindings_path "$current_keybindings"

echo "Custom keybindings have been updated!"
