#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/utils.sh"
cd "$SCRIPT_DIR"

dotfiles_trash_directory_contents .config
dotfiles_trash_directory_contents .claude
dotfiles_trash_directory_contents .vscode

# Copy config directories
cp -r ~/.config/kitty .config
cp -r ~/.config/nvim .config
cp -r ~/.config/tmux .config
cp -r ~/.config/bat .config
cp -r ~/.config/delta .config
cp -r ~/.config/ghostty .config
cp -r ~/.config/opencode .config
cp -r ~/.claude/CLAUDE.md .claude

# Copy Cursor settings
CURSOR_USER_DIR="${HOME}/Library/Application Support/Cursor/User"
dotfiles_capture_editor_settings "Cursor" "$CURSOR_USER_DIR" "$SCRIPT_DIR/.vscode"

# Capture installed Cursor extensions
if command -v cursor >/dev/null 2>&1; then
  echo "Capturing Cursor extensions..."
  cursor --list-extensions > extensions.txt
fi

# trash .zshrc
dotfiles_trash_if_exists .gitconfig

# cp ~/.zshrc .
cp ~/.gitconfig .
