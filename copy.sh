trash .config/*
trash .vscode/*

cp -r ~/.config/kitty .config
cp -r ~/.config/nvim .config
mkdir -p .config/tmux && cp -r ~/.config/tmux .config/tmux

cp ~/Library/Application\ Support/Code/User/settings.json .vscode
cp ~/Library/Application\ Support/Code/User/keybindings.json .vscode

trash .zshrc
trash .gitconfig

cp ~/.zshrc .
cp ~/.gitconfig .
