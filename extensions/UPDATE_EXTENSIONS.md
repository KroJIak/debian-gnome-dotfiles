# Обновление расширений для Debian 13

## Новый список расширений

Следующие расширения были обновлены для Debian 13:

1. **block-caribou-36@lxylxy123456.ercli.dev** - блокировка виртуальной клавиатуры
2. **blur-my-shell@aunetx** - размытие фона
3. **clipboard-indicator@tudmotu.com** - индикатор буфера обмена
4. **custom-command-toggle@julian.gse.jsts.xyz** - переключатель пользовательских команд
5. **gsconnect@andyholmes.github.io** - подключение к Android устройствам
6. **just-perfection-desktop@just-perfection** - настройка интерфейса
7. **kando@kando.org** - замена gnome-pie
8. **mediacontrols@cliffniff.github.com** - управление медиа
9. **quicksettings-audio-devices-hider@marcinjahn.com** - скрытие аудио устройств
10. **quick-settings-tweaks@qwreey** - улучшения быстрых настроек
11. **tiling-assistant@leleat-on-github** - помощник тайлинга
12. **top-bar-organizer@julian.gse.jsts.xyz** - организация верхней панели
13. **trayIconsReloaded@selfmade.pl** - иконки в трее
14. **Vitals@CoreCoding.com** - системная информация
15. **user-theme@gnome-shell-extensions.gcampax.github.com** - пользовательские темы

## Как обновить расширения

### Автоматический способ (рекомендуется)

1. Установите все расширения через GNOME Extensions:
   ```bash
   # Установите расширения через браузер или командную строку
   gnome-extensions install block-caribou-36@lxylxy123456.ercli.dev
   gnome-extensions install blur-my-shell@aunetx
   gnome-extensions install clipboard-indicator@tudmotu.com
   gnome-extensions install custom-command-toggle@julian.gse.jsts.xyz
   gnome-extensions install gsconnect@andyholmes.github.io
   gnome-extensions install just-perfection-desktop@just-perfection
   gnome-extensions install kando@kando.org
   gnome-extensions install mediacontrols@cliffniff.github.com
   gnome-extensions install quicksettings-audio-devices-hider@marcinjahn.com
   gnome-extensions install quick-settings-tweaks@qwreey
   gnome-extensions install tiling-assistant@leleat-on-github
   gnome-extensions install top-bar-organizer@julian.gse.jsts.xyz
   gnome-extensions install trayIconsReloaded@selfmade.pl
   gnome-extensions install Vitals@CoreCoding.com
   gnome-extensions install user-theme@gnome-shell-extensions.gcampax.github.com
   ```

2. Настройте расширения под свои предпочтения

3. Создайте бэкап настроек:
   ```bash
   dconf dump /org/gnome/shell/extensions/ > extensions/settings_backup.txt
   ```

4. Скопируйте файлы расширений:
   ```bash
   cp -r ~/.local/share/gnome-shell/extensions/* extensions/backup/
   ```

### Ручной способ

Если у вас уже есть настроенные расширения, просто замените соответствующие папки в `extensions/backup/` на ваши актуальные версии.

## Удаленные расширения

Следующие расширения больше не используются:
- **Bluetooth-Battery-Meter@maniacx.github.com** - заменено на встроенные функции GNOME
- **logomenu@aryan_k** - заменено на kando
- **quick-settings-avatar@d-go** - заменено на встроенные функции GNOME

## Примечания

- Убедитесь, что все расширения совместимы с вашей версией GNOME
- После установки расширений перезагрузите GNOME Shell: `Alt+F2`, затем `r` и `Enter`
- Проверьте, что все расширения работают корректно перед созданием финального бэкапа

