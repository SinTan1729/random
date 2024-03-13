#!/usr/bin/env bash

# This script checks if any tmux panes are open in our current working directory.
# If yes, it switches to that window given it's not busy i.e. only has the shell running.
# If no, it creates a new window and switches to it.
# I use it as a startup command in alacritty.

target_path="$(pwd -P)"

tmux list-panes -s -F '#{window_id} #{pane_id} #{pane_current_path} #{pane_current_command}' \
| while IFS=' ' read -r window pane path cmd; do
    [[ "$path" = "$target_path" && " fish bash zsh " =~ " $cmd " ]] \
        && tmux select-pane -t "$pane" && tmux select-window -t "$window" && exit 0
done || tmux new-window -c "$target_path"

tmux attach -d
