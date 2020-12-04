# start emacsclient to pop up an emacs frame already in the deft buffer
# this relies on emacs having the 'make-deft-frame' function defined

function deft
    set eclient /usr/bin/emacsclient

    command $eclient -a "" -e "(make-deft-frame)"
end
