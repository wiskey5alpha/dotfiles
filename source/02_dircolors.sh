

alias ls='ls --color'
DB=~/.dircolors
test -r $DB && eval "$(dircolors -b $DB)"
