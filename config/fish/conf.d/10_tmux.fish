#  use tmux whenever we are interactive (as opposed to in a script)

if status is-interactive
    and not set -q TMUX
    exec tmux new-session -A -s main
end
