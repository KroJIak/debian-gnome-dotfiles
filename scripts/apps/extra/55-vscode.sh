#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo snap install code --classic

code_cmd=""
if command -v code >/dev/null 2>&1; then
	code_cmd="code"
elif [ -x "/snap/bin/code" ]; then
	code_cmd="/snap/bin/code"
else
	echo "VS Code CLI not found after install." >&2
	exit 1
fi

extensions=(
	ckolkman.vscode-postgres
	esbenp.prettier-vscode
	github.copilot-chat
	golang.go
	johnny-zhao.oai-compatible-copilot
	mikestead.dotenv
	ms-azuretools.vscode-containers
	ms-azuretools.vscode-docker
	ms-python.debugpy
	ms-python.python
	ms-python.vscode-pylance
	ms-python.vscode-python-envs
	ms-toolsai.jupyter
	ms-toolsai.jupyter-keymap
	ms-toolsai.jupyter-renderers
	ms-toolsai.vscode-jupyter-cell-tags
	ms-toolsai.vscode-jupyter-slideshow
	ms-vscode-remote.remote-containers
	ms-vscode-remote.remote-ssh
	ms-vscode-remote.remote-ssh-edit
	ms-vscode.cmake-tools
	ms-vscode.cpptools
	ms-vscode.cpptools-extension-pack
	ms-vscode.cpptools-themes
	ms-vscode.remote-explorer
	naumovs.color-highlight
	qwtel.sqlite-viewer
	redhat.vscode-yaml
	repreng.csv
	ritwickdey.liveserver
	tomoki1207.pdf
	usernamehw.errorlens
)

for ext in "${extensions[@]}"; do
	"$code_cmd" --install-extension "$ext"
done
