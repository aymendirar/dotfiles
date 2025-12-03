# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

export FIGMA_HK=1
export HK_SLOW=1

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dst"

plugins=(git)

export EDITOR='nvim'

export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig:/usr/local/opt/zlib/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig:/usr/local/opt/openssl@3/lib/pkgconfig:$PKG_CONFIG_PATH"
eval "$(rbenv init -)"
export RACK_ENV=development
export PATH="$PATH:$HOME/.cargo/bin:$(go env GOPATH)/bin:/opt/homebrew/bin"

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

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(zoxide init zsh)"

export MISE_ENV=macos # loads mise.macos.toml
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
source <(carapace _carapace)
eval "$(mise activate zsh)"

eval "$(brew shellenv)"

export GLOBAL_GEMFILE="~/figma/figma/Gemfile"
