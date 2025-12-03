#!/bin/bash
set -xeuo pipefail

# this is to be run on a devcontainer

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

if [ -d "~/.config/nvim" ]; then
  rm -rf ~/.config/nvim
fi

if [ -d "~/.config/tmux" ]; then
  rm -rf ~/.config/tmux
fi

if [ -f "~/.gitconfig" ]; then
  rm .gitconfig
fi

if [ -f "~/.zshrc" ]; then
  rm .zshrc
fi

cp -r .config/nvim ~/.config
cp -r .config/tmux ~/.config
cp .gitconfig ~
cp work.zshrc ~/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

source ~/.zshrc

# need to install TPM for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

~/nvim-linux-x86_64/bin/nvim --headless "+Lazy! install" +qa
