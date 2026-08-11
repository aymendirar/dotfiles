#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/utils.sh"
cd "$SCRIPT_DIR"

# Only install Cursor extensions when --cursor is passed
install_cursor=false
for arg in "$@"; do
  [[ "$arg" == "--cursor" ]] && install_cursor=true
done

# don't update .vimrc, .zshrc

dotfiles_trash_if_exists ~/.config/kitty
dotfiles_trash_if_exists ~/.config/nvim
dotfiles_trash_if_exists ~/.config/tmux
dotfiles_trash_if_exists ~/.config/ghostty

# Copy config directories
mkdir -p ~/.config ~/.claude ~/.codex
cp -r .config/kitty ~/.config
cp -r .config/nvim ~/.config
cp -r .config/tmux ~/.config
cp -r .config/ghostty ~/.config
cp -r .config/tmux/tmux.conf ~/
cp -r .config/bat ~/.config
cp -r .config/delta ~/.config
cp .claude/CLAUDE.md ~/.claude/CLAUDE.md
dotfiles_force_symlink "${HOME}/.claude/CLAUDE.md" ~/.codex/AGENTS.md

# Update opencode config (preserve node_modules)
mkdir -p ~/.config/opencode
rm -f ~/.config/opencode/opencode.json ~/.config/opencode/tui.json
rm -rf ~/.config/opencode/themes
cp .config/opencode/opencode.json .config/opencode/tui.json ~/.config/opencode
cp -r .config/opencode/themes ~/.config/opencode

# Copy shared settings to Cursor and VS Code
CURSOR_USER_DIR="${HOME}/Library/Application Support/Cursor/User"
VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User"

dotfiles_update_editor_settings "Cursor" "$SCRIPT_DIR/.vscode" "$CURSOR_USER_DIR"
dotfiles_update_editor_settings "VS Code" "$SCRIPT_DIR/.vscode" "$VSCODE_USER_DIR"

# Install Cursor extensions
if [[ "$install_cursor" == true ]] && command -v cursor >/dev/null 2>&1 && [[ -f extensions.txt ]]; then
  echo "Installing Cursor extensions..."
  while read -r extension; do
    [[ -n "$extension" ]] && cursor --install-extension "$extension"
  done < extensions.txt
fi

dotfiles_trash_if_exists ~/.gitconfig

cp .gitconfig ~
