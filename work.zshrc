# Path to your Oh My Zsh installation.
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH="$HOME/.oh-my-zsh"

export FIGMA_HK=1
export HK_SLOW=1

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dst"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

export RACK_ENV=development
export PATH="$PATH:$HOME/.cargo/bin:$(go env GOPATH)/bin:/usr/local/mise/installs/neovim/0.11.5/nvim-linux-x86_64/bin/nvim:/home/ubuntu/.fzf/bin"

export AWS_CONFIG_FILE="$HOME/figma/figma/config/aws/sso_config"

alias v="nvim"
alias gdiff="git diff -- ':!*/package-lock.json' ':!*/yarn.lock'"
alias gd="git diff"
alias gs="git status"
alias zshrc="v ~/.zshrc"
alias config="cd ~/.config/nvim && v ."
alias tmux-config="cd ~/.config/tmux && v tmux.conf"

alias nuke-swaps="rm ~/.local/state/nvim/swap/*"
alias source-zshrc="source ~/.zshrc"
alias source-tmux="tmux source ~/.config/tmux/tmux.conf"
alias tmux-kill-rest="tmux kill-session -a"
alias tmux-attach="tmux attach -d -t"

export GLOBAL_GEMFILE="~/figma/figma/Gemfile"
