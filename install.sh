#!/bin/zsh
set -euxo pipefail

# this is to be run on a devcontainer

SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/utils.sh"
cd "$SCRIPT_DIR"

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

for target in \
  "${HOME}/.config/nvim" \
  "${HOME}/.config/tmux" \
  "${HOME}/.gitconfig" \
  "${HOME}/.gitignore_global" \
  "${HOME}/.config/bat" \
  "${HOME}/.config/delta" \
  "${HOME}/.config/opencode" \
  "${HOME}/.zshrc"; do
  dotfiles_remove_if_exists "$target"
done


# Copy config files
mkdir -p ~/.config ~/.claude ~/.codex
cp .claude/CLAUDE.md ~/.claude/CLAUDE.md
dotfiles_force_symlink "${HOME}/.claude/CLAUDE.md" "${HOME}/.codex/AGENTS.md"
cp -r .config/nvim ~/.config
cp -r .config/tmux ~/.config
cp -r .config/bat ~/.config
cp -r .config/delta ~/.config
mkdir -p ~/.config/opencode/themes
cp .config/opencode/opencode.json .config/opencode/tui.json ~/.config/opencode
cp -r .config/opencode/themes ~/.config/opencode
cp work.gitconfig ~/.gitconfig
cp .gitignore_global ~
cp work.zshrc ~/.zshrc

export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ] && git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# need to install TPM for tmux
[ ! -d "${HOME}/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# needed for sorbet
sudo mkdir -p ~/figma/figma/.cache/sorbet-vsc
sudo chown -R $USER:$USER ~/figma/figma/.cache/sorbet-vsc
chmod -R 755 ~/figma/figma/.cache/sorbet-vsc

sudo mkdir -p ~/figma/figma/.cache/sorbet-githook
sudo chown -R $USER:$USER ~/figma/figma/.cache/sorbet-githook
chmod -R 755 ~/figma/figma/.cache/sorbet-githook

# install tools
mise use -g bat
mise use -g delta
mise use -g neovim@0.11.5
mise use -g prettier
mise use -g stylua

mise exec -- nvim --headless "+Lazy! install" +qa
mise exec -- bat cache --build

source "${HOME}/.zshrc"
