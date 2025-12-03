#!/bin/bash
set -xuo pipefail

# this is to be run on a devcontainer

# change to the script's directory
cd "$(dirname "$0")"

install_fzf() {
  if [ ! -d "${HOME}/.fzf" ]; then
    rm -rf "${HOME}/.fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  fi

  ~/.fzf/install --all
}

if ! fzf --version ; then
  install_fzf
fi

if [ -d "${HOME}/.config/nvim" ]; then
  rm -rf "${HOME}/.config/nvim"
fi

if [ -d "${HOME}/.config/tmux" ]; then
  rm -rf "${HOME}/.config/tmux"
fi

if [ -f "${HOME}/.gitconfig" ]; then
  rm "${HOME}/.gitconfig"
fi

if [ -f "${HOME}/.zshrc" ]; then
  rm "${HOME}/.zshrc"
fi

cp -r .config/nvim ~/.config
cp -r .config/tmux ~/.config
cp .gitconfig ~
cp work.zshrc ~/.zshrc

export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

source ~/.zshrc

# need to install TPM for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

nvim --headless "+Lazy! install" +qa
