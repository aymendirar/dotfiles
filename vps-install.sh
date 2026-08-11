#!/usr/bin/env bash
set -euo pipefail

# minimal, idempotent dotfiles setup for a fresh ubuntu vps.
# installs zsh + oh-my-zsh, tmux + tpm, neovim/bat/delta/just/go/ruby/node/opencode (via mise), fzf, docker,
# and symlinks this repo's configs into place. safe to re-run.

DOTFILES_REPO="${DOTFILES_REPO:-git@github.com:adirar111/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"
USING_LOCAL_CHECKOUT=false
if [ -d "$SCRIPT_DIR/.config/nvim" ]; then
  DOTFILES_DIR="$SCRIPT_DIR"
  USING_LOCAL_CHECKOUT=true
fi

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

echo "==> apt packages"
$SUDO apt-get update -y
$SUDO apt-get install -y git curl ca-certificates zsh tmux unzip build-essential ripgrep fd-find \
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libncurses5-dev libffi-dev libgdbm-dev autoconf

echo "==> dotfiles repo at $DOTFILES_DIR"
if [ "$USING_LOCAL_CHECKOUT" = true ]; then
  : # already in place (e.g. synced from another machine)
elif [ ! -d "$DOTFILES_DIR/.git" ]; then
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  git -C "$DOTFILES_DIR" pull --ff-only
fi

echo "==> oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "==> mise (neovim, bat, delta, just, go, ruby, node, opencode)"
if [ ! -x "$HOME/.local/bin/mise" ]; then
  curl https://mise.run | sh
fi
MISE="$HOME/.local/bin/mise"
"$MISE" use -g neovim@0.11.5 bat delta just go ruby node github:anomalyco/opencode

echo "==> fzf"
if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi
"$HOME/.fzf/install" --key-bindings --completion --no-update-rc >/dev/null

echo "==> tmux plugin manager"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true

echo "==> docker"
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | $SUDO sh
fi
$SUDO systemctl enable --now docker
DOCKER_USER="${USER:-$(id -un)}"
if [ "$(id -u)" -ne 0 ] && ! id -nG "$DOCKER_USER" | grep -qw docker; then
  $SUDO usermod -aG docker "$DOCKER_USER"
  echo "    added $DOCKER_USER to docker group (log out/in, or 'newgrp docker', for it to take effect)"
fi

echo "==> symlinking configs"
dotfiles_backup_and_symlink "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"
dotfiles_backup_and_symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
dotfiles_backup_and_symlink "$DOTFILES_DIR/.config/tmux" "$HOME/.config/tmux"
dotfiles_backup_and_symlink "$DOTFILES_DIR/.config/bat" "$HOME/.config/bat"
dotfiles_backup_and_symlink "$DOTFILES_DIR/.config/delta" "$HOME/.config/delta"
dotfiles_backup_and_symlink "$DOTFILES_DIR/.config/opencode" "$HOME/.config/opencode"
dotfiles_backup_and_symlink "$DOTFILES_DIR/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
dotfiles_backup_and_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
dotfiles_backup_and_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
dotfiles_backup_and_symlink "$DOTFILES_DIR/vps.zshrc" "$HOME/.zshrc"

echo "==> default shell"
if [ "$(basename "$SHELL")" != "zsh" ]; then
  $SUDO chsh -s "$(command -v zsh)" "${USER:-$(id -un)}"
fi

echo "==> installing nvim plugins"
"$MISE" exec -- nvim --headless "+Lazy! sync" +qa

echo "done. run 'exec zsh' (or start a new session) to pick up ~/.zshrc"
