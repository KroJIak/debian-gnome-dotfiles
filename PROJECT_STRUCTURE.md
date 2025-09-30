# 📁 Структура проекта Debian GNOME Dotfiles

## 🎯 Обзор
Этот проект представляет собой комплексную систему настройки Debian с GNOME, включающую все необходимые компоненты для создания современного и функционального рабочего окружения.

## 📂 Детальная структура

### 🏠 Корневая директория
```
debian-gnome-dotfiles/
├── 📄 install.sh              # Главный установщик с прогресс-баром
├── 📄 README.md               # Основная документация
├── 📄 README_OLD.md           # Старая документация (архив)
├── 📄 PROJECT_STRUCTURE.md    # Этот файл
└── 📄 LICENSE                 # Лицензия проекта
```

### 🖼️ Assets (Ресурсы)
```
assets/
├── 🖼️ btop.png                # Скриншот btop++
├── 🖼️ desktop.png             # Скриншот рабочего стола
├── 🎬 gnome-pie.gif           # Анимация Gnome Pie
├── 🖼️ media-player-and-theme.png # Скриншот медиаплеера и темы
├── 🎬 switch-wayland-to-x11.gif # Анимация переключения Wayland→X11
└── 🖼️ terminal.png            # Скриншот терминала
```

### ⚙️ Config (Конфигурации)
```
config/
├── 🐟 fish/                   # Fish Shell
│   ├── config.fish            # Основная конфигурация
│   ├── fish_variables         # Переменные Fish
│   └── functions/
│       └── fish_prompt.fish   # Кастомный промпт
├── 📸 flameshot/              # Flameshot (скриншоты)
│   └── flameshot.ini          # Настройки Flameshot
├── 🖥️ kitty/                  # Kitty Terminal
│   └── kitty.conf             # Конфигурация терминала
└── 📊 neofetch/               # Neofetch
    └── config.conf            # Настройки Neofetch
```

### 🔌 Extensions (Расширения GNOME)
```
extensions/
├── 📄 settings_backup.txt     # Бэкап настроек расширений
├── 📄 UPDATE_EXTENSIONS.md    # Документация по обновлению
└── 📁 backup/                 # Бэкапы расширений
    ├── block-caribou-36@lxylxy123456.ercli.dev/
    ├── blur-my-shell@aunetx/
    ├── clipboard-indicator@tudmotu.com/
    ├── custom-command-toggle@julian.gse.jsts.xyz/
    ├── gsconnect@andyholmes.github.io/
    ├── just-perfection-desktop@just-perfection/
    ├── kando@kando.org/
    ├── mediacontrols@cliffniff.github.com/
    ├── quicksettings-audio-devices-hider@marcinjahn.com/
    ├── quick-settings-tweaks@qwreey/
    ├── tiling-assistant@leleat-on-github/
    ├── top-bar-organizer@julian.gse.jsts.xyz/
    ├── trayIconsReloaded@selfmade.pl/
    └── Vitals@CoreCoding.com/
```

### 🎨 GRUB Theme (Тема загрузчика)
```
grub-theme/
├── 📄 cubes.plymouth          # Скрипт темы Plymouth
├── 📄 cubes.script            # Скрипт анимации
├── 📄 LICENSE                 # Лицензия темы
└── 🖼️ progress-*.png          # Кадры анимации загрузки (0-79)
```

### 🏠 Home (Домашние файлы)
```
home/
├── 🖼️ background2K.png        # Фоновое изображение
└── 🖼️ gdm_background2K.png    # Фон экрана входа
```

### 📜 Scripts (Скрипты установки)

#### 📦 Apps (Приложения)
```
scripts/apps/
├── 🌐 chrome.sh               # Установка Google Chrome
├── 💻 cursor.sh                # Установка Cursor IDE
├── 🐳 docker.sh               # Установка Docker
├── 📱 optional_apps.sh         # Дополнительные приложения
├── 🗑️ remove_trash.sh         # Очистка системы
├── 📦 required_apps.sh        # Обязательные приложения
├── 📦 snap.sh                 # Настройка Snap
└── 🎵 yandex_music.sh         # Установка Yandex Music
```

#### ⚙️ Custom (Кастомные настройки)
```
scripts/custom/
├── 🖼️ add_images.sh           # Добавление изображений
├── ⚙️ config.sh                # Копирование конфигураций
├── 🖥️ display_settings.sh     # Настройки дисплея
├── 🔌 enable_extensions.sh    # Включение расширений
├── 📁 grub/                   # Настройка GRUB
│   ├── 📄 grub                # Конфигурация GRUB
│   ├── 📄 setup.sh            # Установка темы GRUB
│   ├── 📄 dedsec_theme.sh     # Установка темы DedSec
│   ├── 📄 menu_manager.sh     # Менеджер настроек GRUB
│   └── 📄 README.md           # Документация GRUB
├── 📁 home_folders/           # Настройка домашних папок
├── ⌨️ keybinds/               # Настройки горячих клавиш
├── 🔌 set_extensions.sh       # Установка расширений
├── ⚙️ settings.sh             # Системные настройки
├── 🎨 themes.sh               # Применение тем
└── 🔐 update_ssh_config.sh   # Обновление SSH
```

#### 🔧 Fixes (Исправления)
```
scripts/fixes/
└── 📁 huawei_sound_fix/       # Исправление звука Huawei
    ├── 📄 install.sh          # Скрипт установки
    ├── 📄 huawei-sound.service # Сервис звука
    └── 📄 huawei-sound.sh     # Скрипт исправления
```

## 🎯 Принципы организации

### 📋 Логическая структура
1. **Разделение по функциональности**: каждый тип компонентов в своей папке
2. **Иерархическая организация**: подпапки для группировки связанных файлов
3. **Документация рядом с кодом**: README файлы в соответствующих папках
4. **Версионность**: сохранение старых версий для истории

### 🔄 Процесс установки
1. **Этап 1**: Приложения (apps/)
2. **Этап 2**: Исправления (fixes/)
3. **Этап 3**: Настройки (custom/)

### 📚 Документация
- **README.md**: Основная документация проекта
- **PROJECT_STRUCTURE.md**: Этот файл со структурой
- **UPDATE_EXTENSIONS.md**: Документация по расширениям
- **README.md в подпапках**: Специфичная документация

## 🛠️ Расширение проекта

### ➕ Добавление новых компонентов
1. **Приложения**: Добавьте скрипт в `scripts/apps/`
2. **Настройки**: Добавьте скрипт в `scripts/custom/`
3. **Исправления**: Добавьте в `scripts/fixes/`
4. **Конфигурации**: Добавьте в `config/`

### 📝 Обновление документации
1. Обновите соответствующий README.md
2. Добавьте информацию в PROJECT_STRUCTURE.md
3. Обновите основной README.md при необходимости

## 🎨 Визуальные элементы

### 📁 Эмодзи для файлов
- 📄 Обычные файлы
- 📁 Папки
- 🖼️ Изображения
- 🎬 Анимации
- 📜 Скрипты
- ⚙️ Конфигурации
- 🔌 Расширения
- 🎨 Темы

### 🎯 Цветовая схема
- 🟢 Зеленый: Успешные операции
- 🔴 Красный: Ошибки
- 🟡 Желтый: Предупреждения
- 🔵 Синий: Информация
- 🟣 Фиолетовый: Заголовки
- ⚪ Белый: Основной текст

---

**💡 Совет**: Используйте эту структуру как справочник при работе с проектом.
