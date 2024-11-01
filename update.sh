# don't update .vimrc, .zshrc

trash ~/.config/*
trash ~/Library/Application\ Support/Code/User/*.json

cp -r .config/kitty ~/.config
cp -r .config/nvim ~/.config
mkdir -p ~/.config/tmux && cp .config/tmux/tmux.conf ~/.config/tmux

cp .vscode/settings.json ~/Library/Application\ Support/Code/User
cp .vscode/keybindings.json ~/Library/Application\ Support/Code/User

trash ~/.gitconfig

cp .gitconfig ~
