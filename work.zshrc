# Path to your Oh My Zsh installation.
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH="$HOME/.oh-my-zsh"

export FIGMA_HK=1
export HK_SLOW=1

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dst"

plugins=(
  git 
  zsh-syntax-highlighting 
  zsh-autosuggestions 
)

source $ZSH/oh-my-zsh.sh

# Override devcontainer completer to remove _correct _approximate (causes recursive loops)
zstyle ':completion:*' completer _expand _complete

export EDITOR='nvim'

export RACK_ENV=development
export PATH="$PATH:$HOME/.cargo/bin:$(go env GOPATH)/bin:/home/ubuntu/.fzf/bin"

export AWS_CONFIG_FILE="$HOME/figma/figma/config/aws/sso_config"

alias v="nvim"
alias nvim-tunnel="et -N -t 16666:6666 devcontainer.aymen-devbox.adirar.coder"
alias nvim-remote="nvim --remote-ui --server 127.0.0.1:16666"
alias gdiff="git diff -- ':!*/package-lock.json' ':!*/yarn.lock'"
alias gd="hunk diff"
alias gdm='gd origin/master... -- . ":(exclude)*test*"'
alias gdt='gd origin/master... -- "*test*"'
alias gdc='gd HEAD -- . ":(exclude)*test*"'
alias gdct='gd HEAD -- "*test*"'
alias gs="git status"
alias zshrc="v ~/.zshrc"
alias config="cd ~/.config/nvim && v ."
alias tmux-config="cd ~/.config/tmux && v tmux.conf"

alias nuke-swaps="rm ~/.local/state/nvim/swap/*"
alias source-zshrc="source ~/.zshrc"
alias update-dotfiles="coder dotfiles https://github.com/figma/dotfiles -y && exec zsh"
alias source-tmux="tmux source ~/.config/tmux/tmux.conf"
alias tmux-kill-rest="tmux kill-session -a"
alias tmux-attach="tmux attach -d -t"

alias claude="claude --dangerously-skip-permissions"
alias cursor="agent --yolo --approve-mcps --trust"

# in a blob:none partial clone, push lazily fetches every missing object it
# checks against the remote's refs, which can download millions of objects and
# hang for an hour. disable lazy fetching for pushes only, since checkout, diff,
# and rebase still need it.
git() {
  local arg skip_value=0
  for arg in "$@"; do
    if (( skip_value )); then
      skip_value=0
    elif [[ $arg == (-C|-c|--git-dir|--work-tree|--namespace|--config-env) ]]; then
      skip_value=1
    elif [[ $arg != -* ]]; then
      [[ $arg == push ]] && local -x GIT_NO_LAZY_FETCH=1
      break
    fi
  done
  command git "$@"
}

# gt pushes in submit and its aliases (s, ss), and passes unknown commands such
# as push through to git. restack, sync, and checkout still need lazy fetching.
gt() {
  local arg skip_value=0
  for arg in "$@"; do
    if (( skip_value )); then
      skip_value=0
    elif [[ $arg == --cwd ]]; then
      skip_value=1
    elif [[ $arg != -* ]]; then
      [[ $arg == (submit|s|ss|push) ]] && local -x GIT_NO_LAZY_FETCH=1
      break
    fi
  done
  command gt "$@"
}

export GLOBAL_GEMFILE="~/figma/figma/Gemfile"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
