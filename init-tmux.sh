#! /bin/bash

tmux new -d -s 'personal' -n 'diarrhea'
sleep 1

tmux send-keys -t 'diarrhea' 'diarrhea' Enter

tmux new-window -n 'aio' -t 'personal'
sleep 1
tmux send-keys -t 'aio' 'aio' Enter

tmux new -d -s 'configs' -n 'nvim'
sleep 1

tmux send-keys -t 'nvim' 'config' Enter

tmux new-window -n 'tmux' -t 'config'
sleep 1
tmux send-keys -t 'tmux' 'tmux-config' Enter

tmux new-window -n 'dotfiles' -t 'config'
sleep 1
tmux send-keys -t 'dotfiles' 'dotfiles' Enter
