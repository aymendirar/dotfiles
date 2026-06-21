#!/bin/zsh
set -uo pipefail

# don't update .vimrc, .zshrc

trash ~/.config/kitty
trash ~/.config/nvim
trash ~/.config/tmux
trash ~/.config/ghostty

# Copy config directories
cp -r .config/kitty ~/.config
cp -r .config/nvim ~/.config
cp -r .config/tmux ~/.config
cp -r .config/ghostty ~/.config
cp -r .config/tmux/tmux.conf ~/
cp -r .config/bat ~/.config
cp -r .config/delta ~/.config
cp -r .claude ~/.claude
cp -r .config/bat .config
cp -r .config/delta .config

# Copy settings to Cursor
CURSOR_USER_DIR="${HOME}/Library/Application Support/Cursor/User"

# Update Cursor settings if directory exists
if [[ -d "${CURSOR_USER_DIR}" ]]; then
  echo "Updating Cursor settings..."
  trash "${CURSOR_USER_DIR}/"*.json 2>/dev/null || true
  cp .vscode/settings.json "${CURSOR_USER_DIR}/"
  cp .vscode/keybindings.json "${CURSOR_USER_DIR}/"
else
  echo "Warning: No Cursor installation found"
fi

# Install Cursor extensions
if command -v cursor >/dev/null 2>&1 && [[ -f extensions.txt ]]; then
  echo "Installing Cursor extensions..."
  while read -r extension; do
    [[ -n "$extension" ]] && cursor --install-extension "$extension"
  done < extensions.txt
fi

trash ~/.gitconfig

cp .gitconfig ~
