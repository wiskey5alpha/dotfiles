# start emacsclient to pop up an emacs frame already in the deft buffer
# this relies on emacs having the 'make-deft-frame' function defined

function deft
    set eclient /usr/bin/emacsclient
    set client_options -a "" -e
    set emacs_function "(make-deft-frame)"
    command $eclient $client_options $emacs_function
end
