# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

alias ll='ls -al'

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"


# Aliasing eachdir like this allows you to use aliases/functions as commands.
alias eachdir=". eachdir"

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

# Fast directory switching
mkdir -p $DOTFILES/caches/z
export _Z_NO_PROMPT_COMMAND=1
export _Z_DATA=$DOTFILES/caches/z/z
. $DOTFILES/vendor/z/z.sh
