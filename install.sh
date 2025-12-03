#!/bin/bash
set -xeuo pipefail

install_fzf() {
  if [ ! -d "${HOME}/.fzf" ]; then
    rm -rf "${HOME}/.fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  fi

  ~/.fzf/install --all
}

# this is to be run on a devcontainer
install_fzf

sudo apt install neovim

rm -rf .config/nvim
rm -rf .config/tmux
rm .gitconfig
rm .zshrc

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

nvim --headless "+Lazy! install" +qa
