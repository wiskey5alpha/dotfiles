# start emacsclient to pop up an emacs frame already in capture mode
# this relies on emacs having the 'make-capture-frame' function defined

function capture
    set eclient /usr/bin/emacsclient
    set client_options -a "" -e
    set emacs_function "(make-capture-frame)"
    command $eclient $client_options $emacs_function
end
