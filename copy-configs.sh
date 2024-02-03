rm -rf .config/*

cp -r ~/.config/kitty .config
cp -r ~/.config/nvim .config
cp -r ~/.config/tmux .config

rm .zshrc
rm .gitconfig
rm .vimrc

cp ~/.zshrc .
cp ~/.gitconfig .
cp ~/.vimrc .
