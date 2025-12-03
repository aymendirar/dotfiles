# this is to be run on a devcontainer
set -xeuo pipefail

sudo apt install fzf
sudo apt install nvim

rm -rf .config/nvim
rm -rf .config/tmux
rm .gitconfig
rm .zshrc

cp -r .config/nvim ~/.config
cp -r .config/tmux ~/.config
cp .gitconfig ~
cp work.zshrc ~/.zshrc

source ~/.zshrc

# need to install TPM for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

nvim --headless "+Lazy! install" +qa
