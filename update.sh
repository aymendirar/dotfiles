#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
STATE_REPO="${STATE_REPO:-git@github.com:aymendirar/state.git}"
STATE_DIR="${STATE_DIR:-$HOME/state}"
source "$SCRIPT_DIR/utils.sh"
cd "$SCRIPT_DIR"

if ! dotfiles_ensure_git_checkout "$STATE_REPO" "$STATE_DIR"; then
  printf 'warning: personal state checkout unavailable at %s\n' "$STATE_DIR" >&2
fi

# Only install Cursor extensions when --cursor is passed
install_cursor=false
for arg in "$@"; do
  [[ "$arg" == "--cursor" ]] && install_cursor=true
done

# don't touch .zshrc (may have machine-local edits)

# symlink config files (repo is the source of truth)
mkdir -p ~/.config ~/.claude ~/.codex
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/kitty" "${HOME}/.config/kitty"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/nvim" "${HOME}/.config/nvim"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/tmux" "${HOME}/.config/tmux"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/herdr/config.toml" "${HOME}/.config/herdr/config.toml"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/ghostty" "${HOME}/.config/ghostty"
dotfiles_ensure_directory "${HOME}/.config/cmux"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/cmux/cmux.json" "${HOME}/.config/cmux/cmux.json"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/bat" "${HOME}/.config/bat"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/delta" "${HOME}/.config/delta"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/hunk" "${HOME}/.config/hunk"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/worktrunk" "${HOME}/.config/worktrunk"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.agents/global.md" "${HOME}/.claude/CLAUDE.md"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.agents/global.md" "${HOME}/.codex/AGENTS.md"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.agents/global.md" "${HOME}/.config/figaro/AGENTS.md"
# cursor only always-applies a rule as an .mdc carrying alwaysApply frontmatter, which global.md declares
dotfiles_backup_and_symlink "$SCRIPT_DIR/.agents/global.md" "${HOME}/.cursor/rules/global.mdc"
dotfiles_link_agent_skills "$SCRIPT_DIR/skills" \
  "${HOME}/.claude/skills" \
  "${HOME}/.codex/skills" \
  "${HOME}/.config/opencode/skills" \
  "${HOME}/.config/figaro/skills"
dotfiles_link_state_skills "$STATE_DIR" "${HOME}/.config/figaro/skills"

# Remove the old LaunchAgent file. Any already-loaded job exits at logout.
FIGMA_MASTER_AGENT_PATH="${HOME}/Library/LaunchAgents/com.adirar.pull-figma-master.plist"
if [ -L "$FIGMA_MASTER_AGENT_PATH" ]; then
  rm "$FIGMA_MASTER_AGENT_PATH"
fi

dotfiles_ensure_directory "${HOME}/.local/state"
dotfiles_install_cron_job \
  "dotfiles: pull-figma-master" \
  "*/5 * * * * \"$SCRIPT_DIR/bin/pull-figma-master\" >> \"$HOME/.local/state/pull-figma-master.log\" 2>&1"

# opencode writes runtime state (auth.json) into this dir, so keep it real and link only our files
dotfiles_ensure_directory "${HOME}/.config/opencode"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/opencode/opencode.json" "${HOME}/.config/opencode/opencode.json"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/opencode/tui.json" "${HOME}/.config/opencode/tui.json"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/opencode/themes" "${HOME}/.config/opencode/themes"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.agents/global.md" "${HOME}/.config/opencode/AGENTS.md"

dotfiles_backup_and_symlink "$SCRIPT_DIR/.gitconfig" "${HOME}/.gitconfig"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.gitconfig-work" "${HOME}/.gitconfig-work"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.gitignore_global" "${HOME}/.gitignore_global"

# client-side helpers; the devbox has no use for these, so they are not linked
# by install.sh
dotfiles_ensure_directory "${HOME}/.local/bin"
dotfiles_backup_and_symlink "$SCRIPT_DIR/bin/coder-et" "${HOME}/.local/bin/coder-et"

if command -v tmux >/dev/null 2>&1; then
  dotfiles_install_tmux_plugins
fi

# editors do atomic-rename saves that would clobber a symlink, so copy their settings instead
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
