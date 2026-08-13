#!/bin/zsh
set -euo pipefail

# this is to be run on a devcontainer

SCRIPT_DIR="${0:A:h}"
STATE_REPO="${STATE_REPO:-https://github.com/adirar-figma/state.git}"
STATE_DIR="${STATE_DIR:-$HOME/state}"
source "$SCRIPT_DIR/utils.sh"
cd "$SCRIPT_DIR"

if ! dotfiles_ensure_git_checkout "$STATE_REPO" "$STATE_DIR"; then
  printf 'warning: work state checkout unavailable at %s\n' "$STATE_DIR" >&2
fi

# install oh my zsh
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  if [ -d "$HOME/.oh-my-zsh" ]; then
    mv "$HOME/.oh-my-zsh" "$HOME/.oh-my-zsh.prev"
  fi
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  if [ -d "$HOME/.oh-my-zsh.prev/custom" ]; then
    cp -r "$HOME/.oh-my-zsh.prev/custom/." "$HOME/.oh-my-zsh/custom/"
    rm -rf "$HOME/.oh-my-zsh.prev"
  fi
fi

install_fzf() {
  if [ ! -d "${HOME}/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  fi

  ~/.fzf/install --all
}

if ! fzf --version ; then
  install_fzf
fi

# symlink config files (repo is the source of truth)
dotfiles_ensure_directory "${HOME}/.config"
dotfiles_ensure_directory "${HOME}/.claude"
dotfiles_ensure_directory "${HOME}/.codex"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.agents/global.md" "${HOME}/.claude/CLAUDE.md"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.agents/global.md" "${HOME}/.codex/AGENTS.md"
# cursor only always-applies a rule as an .mdc carrying alwaysApply frontmatter, which global.md declares
dotfiles_backup_and_symlink "$SCRIPT_DIR/.agents/global.md" "${HOME}/.cursor/rules/global.mdc"
# private skills live in the state repo; surface them to every agent
dotfiles_link_state_skills "$STATE_DIR" \
  "${HOME}/.claude/skills" \
  "${HOME}/.codex/skills" \
  "${HOME}/.config/opencode/skills"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/nvim" "${HOME}/.config/nvim"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/tmux" "${HOME}/.config/tmux"
# eternal terminal: the repo owns the server config, and the et:* tasks land in
# mise's global task directory so `mise run et:start` works from any cwd
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/et/et.cfg" "${HOME}/.config/et/et.cfg"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/mise/tasks/et" "${HOME}/.config/mise/tasks/et"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/bat" "${HOME}/.config/bat"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/delta" "${HOME}/.config/delta"
# opencode writes runtime state (auth.json) into this dir, so keep it real and link only our files
dotfiles_ensure_directory "${HOME}/.config/opencode"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/opencode/opencode.json" "${HOME}/.config/opencode/opencode.json"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/opencode/tui.json" "${HOME}/.config/opencode/tui.json"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.config/opencode/themes" "${HOME}/.config/opencode/themes"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.agents/global.md" "${HOME}/.config/opencode/AGENTS.md"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.gitconfig" "${HOME}/.gitconfig"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.gitconfig-work" "${HOME}/.gitconfig-work"
dotfiles_backup_and_symlink "$SCRIPT_DIR/.gitignore_global" "${HOME}/.gitignore_global"
dotfiles_backup_and_symlink "$SCRIPT_DIR/work.zshrc" "${HOME}/.zshrc"

dotfiles_install_tmux_plugins

export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ] && git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# install tools
mise use -g bat
mise use -g delta
mise use -g neovim@0.11.5
mise use -g prettier
mise use -g stylua

mise exec -- nvim --headless "+Lazy! install" +qa
mise exec -- bat cache --build

# eternal terminal holds a shell open across network changes and laptop sleep,
# which plain ssh drops. no et package ships in the devcontainer image, so
# install from the upstream ppa. the server itself is driven by the et:* mise
# tasks linked above rather than systemd, which the devcontainer does not run.
install_et() {
  if ! command -v add-apt-repository >/dev/null 2>&1; then
    sudo apt-get update -qq && sudo apt-get install -y software-properties-common || return 1
  fi
  sudo add-apt-repository -y ppa:jgmath2000/et &&
    sudo apt-get update -qq &&
    sudo apt-get install -y et
}

if ! command -v etserver >/dev/null 2>&1; then
  echo "installing eternal terminal"
  install_et || echo "[warn] eternal terminal install failed, continuing without it" >&2
fi

if command -v etserver >/dev/null 2>&1; then
  mise run et:start || echo "[warn] could not start etserver, continuing" >&2
else
  echo "[warn] no etserver binary, skipping eternal terminal startup" >&2
fi

set +u
source "${HOME}/.zshrc"
