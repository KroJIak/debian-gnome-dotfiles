
import subprocess

FILE = 'keybinds.txt'
CUSTOM_PATH = '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom'

def run(command: str | list):
    com = command if isinstance(command, list) else command.split()
    response = subprocess.run(com)
    return response

def getCustomKeybindsCount():
    customKeybinds = run('gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings')
    return len(customKeybinds)

def addCustomKeybind(path, name, command, bind):
    # Устанавливаем имя для кастомного бинда
    run(["gsettings", "set",
         f"org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:{path}",
         "name", name])
    # Устанавливаем само сочетание клавиш
    run(["gsettings", "set",
         f"org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:{path}",
         "binding", bind])
    # Устанавливаем команду, которую должен выполнять биндинг
    run(["gsettings", "set",
         f"org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:{path}",
         "command", command])

def main():
    customKeybindsCount = getCustomKeybindsCount()
    with open(FILE) as file:
        for index, line in enumerate(file.readlines(), start=customKeybindsCount):
            name, command, bind = line[1:-1].split('" "')
            path = CUSTOM_PATH + str(index) + '/'
            addCustomKeybind(path, name, command)

if __name__ == '__main__':
    main()