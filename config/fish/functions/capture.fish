# start emacsclient to pop up an emacs frame already in capture mode
# this relies on emacs having the 'make-capture-frame' function defined

function capture
    set eclient /usr/bin/emacsclient

    command $eclient -a "" -e "(make-capture-frame)"
end
