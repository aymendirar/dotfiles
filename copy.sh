#!/bin/zsh
set -uo pipefail

trash .config/*
trash .claude/*
trash .vscode/*

# Copy config directories
cp -r ~/.config/kitty .config
cp -r ~/.config/nvim .config
cp -r ~/.config/tmux .config
cp -r ~/.config/bat .config
cp -r ~/.config/delta .config
cp -r ~/.config/ghostty .config
cp -r ~/.claude/CLAUDE.md .claude

# Ensure .vscode directory exists
mkdir -p .vscode

# Copy Cursor settings
CURSOR_USER_DIR="${HOME}/Library/Application Support/Cursor/User"

if [[ -f "${CURSOR_USER_DIR}/settings.json" ]]; then
  echo "Copying Cursor settings..."
  cp "${CURSOR_USER_DIR}/settings.json" .vscode/
  cp "${CURSOR_USER_DIR}/keybindings.json" .vscode/ 2>/dev/null || true
else
  echo "Warning: No Cursor settings found"
fi

# Capture installed Cursor extensions
if command -v cursor >/dev/null 2>&1; then
  echo "Capturing Cursor extensions..."
  cursor --list-extensions > extensions.txt
fi

# trash .zshrc
trash .gitconfig

# cp ~/.zshrc .
cp ~/.gitconfig .
