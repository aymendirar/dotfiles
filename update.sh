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

# Copy settings to VSCode and Cursor
VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User"
CURSOR_USER_DIR="${HOME}/Library/Application Support/Cursor/User"

# Update VSCode settings if directory exists
if [[ -d "${VSCODE_USER_DIR}" ]]; then
  echo "Updating VSCode settings..."
  trash "${VSCODE_USER_DIR}/"*.json 2>/dev/null || true
  cp .vscode/settings.json "${VSCODE_USER_DIR}/"
  cp .vscode/keybindings.json "${VSCODE_USER_DIR}/"
fi

# Update Cursor settings if directory exists
if [[ -d "${CURSOR_USER_DIR}" ]]; then
  echo "Updating Cursor settings..."
  trash "${CURSOR_USER_DIR}/"*.json 2>/dev/null || true
  cp .vscode/settings.json "${CURSOR_USER_DIR}/"
  cp .vscode/keybindings.json "${CURSOR_USER_DIR}/"
fi

if [[ ! -d "${VSCODE_USER_DIR}" ]] && [[ ! -d "${CURSOR_USER_DIR}" ]]; then
  echo "Warning: Neither VSCode nor Cursor installation found"
fi

trash ~/.gitconfig

cp .gitconfig ~
