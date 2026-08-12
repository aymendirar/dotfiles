#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/utils.sh"
cd "$SCRIPT_DIR"

# all other configs are symlinked, so they already live in the repo;
# only the editor settings are copy-based and need capturing back
dotfiles_trash_directory_contents .vscode

# Copy Cursor settings
CURSOR_USER_DIR="${HOME}/Library/Application Support/Cursor/User"
dotfiles_capture_editor_settings "Cursor" "$CURSOR_USER_DIR" "$SCRIPT_DIR/.vscode"

# Capture installed Cursor extensions
if command -v cursor >/dev/null 2>&1; then
  echo "Capturing Cursor extensions..."
  cursor --list-extensions > extensions.txt
fi
