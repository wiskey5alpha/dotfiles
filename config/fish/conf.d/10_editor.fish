# environment variables {{{
# emacs for all the things
# ALTERNATE_EDITOR is called if emacs server is not running. If its
#     empty emacs --daemon is run and then we connect. which I always
#     want.
# EDITOR is used to determine what text editor to use, by convention
#     this should be a 'terminal editor'
# VISUAL is used to determine what 'gui' text editor to use

set -gx ALTERNATE_EDITOR ""
set -gx EDITOR "edt -nw"
set -gx VISUAL "edt"

# }}}
