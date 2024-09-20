
import subprocess
import os

KEYBINDS_CATEGORIES = {'custom': {'path': '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom', 'txtfile': 'custom.txt'},
                       'wm': {'path': 'org.gnome.desktop.wm.keybindings', 'txtfile': 'wm.txt'},
                       'shell': {'path': 'org.gnome.shell.keybindings', 'txtfile': 'shell.txt'},
                       'media-keys': {'path': 'org.gnome.settings-daemon.plugins.media-keys', 'txtfile': 'media-keys.txt'}}

def run(command: str | list):
    com = command if isinstance(command, list) else command.split()
    response = subprocess.run(com, capture_output=True, text=True)
    return response

def addToCustomKeybindingList(path):
    customKeybindings = run(["gsettings", "get",
                             "org.gnome.settings-daemon.plugins.media-keys",
                             "custom-keybindings"])
    customKeybindings = eval(customKeybindings.stdout) if customKeybindings.stdout.strip() != '@as []' else []
    customKeybindings.append(path)
    customKeybindings = list(set(customKeybindings))
    stringCustomKeybindings = str(customKeybindings).replace('"', "'")
    run(["gsettings", "set",
         "org.gnome.settings-daemon.plugins.media-keys", 
         "custom-keybindings", stringCustomKeybindings])

def addCustomKeybind(path, name, command, bind):
    run(["gsettings", "set",
         f"org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:{path}",
         "name", name])
    run(["gsettings", "set",
         f"org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:{path}",
         "binding", bind])
    run(["gsettings", "set",
         f"org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:{path}",
         "command", command])

def editDefaultKeybind(path, name, bind):
    if bind: run(["gsettings", "set", path, name, f"['{bind}']"])
    else: run(["gsettings", "set", path, name, "[]"])

def addCustomCategory(category):
    with open(category['txtfile']) as file:
        for index, line in enumerate(file.readlines()):
            if not len(line.strip()): continue
            name, command, bind = line.strip()[1:-1].split('" "')
            path = category['path'] + str(index) + '/'
            addCustomKeybind(path, name, command, bind)
            addToCustomKeybindingList(path)

def editDefaultCategory(category):
    with open(category['txtfile']) as file:
        for line in file.readlines():
            if not len(line.strip()): continue
            name, bind = line.strip()[1:-1].split('" "')
            editDefaultKeybind(category['path'], name, bind)

def main():
    for name, category in KEYBINDS_CATEGORIES.items():
        if name == 'custom': addCustomCategory(category)
        else: editDefaultCategory(category)

if __name__ == '__main__':
    main()