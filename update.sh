# don't update .vimrc, .zshrc

trash ~/.config/kitty
trash ~/.config/nvim
trash ~/.config/tmux
trash ~/Library/Application\ Support/Code/User/*.json

cp -r .config/kitty ~/.config
cp -r .config/nvim ~/.config
cp -r .config/tmux ~/.config
cp -r .config/tmux/tmux.conf ~/

cp .vscode/settings.json ~/Library/Application\ Support/Code/User
cp .vscode/keybindings.json ~/Library/Application\ Support/Code/User

trash ~/.gitconfig

cp .gitconfig ~
