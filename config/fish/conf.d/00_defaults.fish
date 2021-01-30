# fish config file


# completions for kitty terminal
kitty +complete setup fish | source
contains ~/.dotfiles/bin $fish_user_paths; or set -Ua fish_user_paths ~/.dotfiles/bin
contains ~/.cask/bin $fish_user_paths; or set -Ua fish_user_paths ~/.cask/bin

# environment variables {{{
# emacs for all the things
# ALTERNATE_EDITOR is called if emacs server is not running. If its
#     empty emacs --daemon is run and then we connect. which I always
#     want.
# EDITOR is used to determine what text editor to use, by convention
#     this should be a 'terminal editor'
# VISUAL is used to determine what 'gui' text editor to use

set -gx ALTERNATE_EDITOR ""
set -gx EDITOR "em"
set -gx VISUAL "edit"

# }}}

set -xg POWERLINE_PREFIX  '/usr/share/powerline'

#  use tmux whenever we are interactive (as opposed to in a script)
if status is-interactive
    and not set -q TMUX
    exec tmux new-session -A -s main
end
