rm -rf .config/*

cp -r ~/.config/kitty .config
cp -r ~/.config/nvim .config
cp ~/.config/tmux/tmux.conf .config

rm .zshrc
rm .gitconfig
rm .vimrc
rm init-tmux.sh

cp ~/.zshrc .
cp ~/.gitconfig .
cp ~/.vimrc .
cp ~/init-tmux.sh .
