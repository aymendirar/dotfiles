export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
ZSH_THEME="dst"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"

eval "$($HOME/.local/bin/mise activate zsh)"

export PATH="$PATH:$HOME/.fzf/bin"
[ -f "$HOME/.fzf/shell/completion.zsh" ] && source "$HOME/.fzf/shell/completion.zsh"
[ -f "$HOME/.fzf/shell/key-bindings.zsh" ] && source "$HOME/.fzf/shell/key-bindings.zsh"

alias v="nvim"
alias fd="fdfind"
alias gs="git status"
alias gd="hunk diff"
alias config="cd ~/.config/nvim && v ."
alias tmux-config="cd ~/.config/tmux && v tmux.conf"
alias zshrc="v ~/.zshrc"
alias source-zshrc="source ~/.zshrc"
alias source-tmux="tmux source ~/.config/tmux/tmux.conf"
