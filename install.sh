#!/bin/zsh
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

if [ -f "${HOME}/.gitignore_global" ]; then
  rm "${HOME}/.gitignore_global"
fi

if [ -d "${HOME}/.config/bat" ]; then
  rm -rf "${HOME}/.config/bat"
fi

if [ -d "${HOME}/.config/delta" ]; then
  rm -rf "${HOME}/.config/delta"
fi


if [ -f "${HOME}/.zshrc" ]; then
  rm "${HOME}/.zshrc"
fi


cp -r .config/nvim ~/.config
cp -r .config/tmux ~/.config
cp -r .config/bat ~/.config
cp -r .config/delta ~/.config
cp .gitconfig ~
cp .gitignore_global ~
cp work.zshrc ~/.zshrc

export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

source "${HOME}/.zshrc"

# need to install TPM for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

nvim --headless "+Lazy! install" +qa

# needed for sorbet lsp
sudo mkdir -p ~/figma/figma/.cache/sorbet-vsc
sudo chown -R $USER:$USER ~/figma/figma/.cache/sorbet-vsc
chmod -R 755 ~/figma/figma/.cache/sorbet-vsc

# install nvim/bat/delta
mise use -g bat
mise use -g delta
mise use -g neovim@0.11.5

bat cache --build

source "${HOME}/.zshrc"
