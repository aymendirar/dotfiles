trash .config/*
trash .vscode/*

cp -r ~/.config/kitty .config
cp -r ~/.config/nvim .config
cp -r ~/.config/tmux .config

cp ~/Library/Application\ Support/Code/User/settings.json .vscode
cp ~/Library/Application\ Support/Code/User/keybindings.json .vscode

trash .zshrc
trash .gitconfig

cp ~/.zshrc .
cp ~/.gitconfig .
