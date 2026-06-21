#!/bin/zsh
set -xuo pipefail

# this is to be run on a devcontainer

# change to the script's directory
cd "$(dirname "$0")"

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


# Copy config files
cp -r .claude/settings.json ~/.claude
cp -r .config/nvim ~/.config
cp -r .config/tmux ~/.config
cp -r .config/bat ~/.config
cp -r .config/delta ~/.config
cp .gitconfig ~
cp .gitignore_global ~
cp work.zshrc ~/.zshrc

# Install Cursor settings if directory exists
CURSOR_USER_DIR="${HOME}/Library/Application Support/Cursor/User"

if [[ -d "${CURSOR_USER_DIR}" ]]; then
  echo "Installing Cursor settings..."
  mkdir -p "${CURSOR_USER_DIR}"
  cp .vscode/settings.json "${CURSOR_USER_DIR}/"
  cp .vscode/keybindings.json "${CURSOR_USER_DIR}/"
fi

# Install Cursor extensions
if command -v cursor >/dev/null 2>&1 && [[ -f extensions.txt ]]; then
  echo "Installing Cursor extensions..."
  while read -r extension; do
    [[ -n "$extension" ]] && cursor --install-extension "$extension"
  done < extensions.txt
fi

export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ] && git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

source "${HOME}/.zshrc"

# need to install TPM for tmux
[ ! -d "${HOME}/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

nvim --headless "+Lazy! install" +qa

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

bat cache --build

source "${HOME}/.zshrc"
