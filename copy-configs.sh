rm -rf .config/*
rm -rf .vscode/*

cp -r ~/.config/kitty .config
cp -r ~/.config/nvim .config
mkdir -p .config/tmux && cp ~/.config/tmux/tmux.conf .config

cp ~/Library/Application\ Support/Code/User/settings.json .vscode
cp ~/Library/Application\ Support/Code/User/keybindings.json .vscode

rm .zshrc
rm .gitconfig
rm .vimrc
rm init-tmux.sh

cp ~/.zshrc .
cp ~/.gitconfig .
cp ~/.vimrc .
cp ~/init-tmux.sh .
