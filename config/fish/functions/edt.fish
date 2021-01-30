
function edt -d "run the emacsclient"
    ##  a wrapper around the emacsclient with lots of options.
    # emacsclient options {{{
    # -nw, -t, --tty 	....................  Open a new Emacs frame on the current terminal
    # -c, --create-frame .................  Create a new frame instead of trying to
    # 			                                use the current Emacs frame
    # -F ALIST, --frame-parameters=ALIST . 	Set the parameters of a new frame
    # -e, --eval ......................... 	Evaluate the FILE arguments as ELisp expressions
    # -n, --no-wait	......................	Don't wait for the server to return
    # -q, --quiet		......................  Don't display messages on success
    # -u, --suppress-output ..............  Don't display return values from the server
    # -d DISPLAY, --display=DISPLAY ......  Visit the file in the given display
    # --parent-id=ID .....................  Open in parent window ID, via XEmbed
    # -s SOCKET, --socket-name=SOCKET ....  Set filename of the UNIX socket for communication
    # -f SERVER, --server-file=SERVER ....  Set filename of the TCP authentication file
    # -a EDITOR, --alternate-editor=EDITOR  Editor to fallback to if the server is not running
    # 			                                If EDITOR is the empty string, start Emacs in daemon
    # 			                                mode and try connecting again
    # -T PREFIX, --tramp=PREFIX ..........  PREFIX to prepend to filenames sent by emacsclient
    #                                       for locating files remotely via Tramp
    # }}}

    set -g DEBUG                # turn on useful messages (set to 1 to turn off)
    set -g emacs_client "/usr/bin/emacsclient"
    set -g use_gui              # not the terminal (true (empty) by default)
    set -g do_stdin 1          # if reading from std-in, turn off some options
    set -g create_frame         # create a new frame
    set -g emacs_options        # build the commandline switches we want to pass to the client
    set -g additional_options   # filenames and other options not pre-configured

    function _show_edt_help
        echo -- '-n --new-window .......... open an new gui frame'
        echo    '-r --replace ............. open in an active gui frame (replace the current buffer)'
        echo    '-t --tty ................. open in terminal'
        echo    '-h --help ................ print this help'
        echo    '-  ....................... connect to stdin'
        return 0
    end

    function _is_emacs_server_running
        if pgrep -U (id -u) -f 'emacs --daemon' > /dev/null
            if set -q $DEBUG; echo "DEBUG: found the daemon process"; end
            return 0
        else
           if set -q $DEBUG; echo "DEBUG: the daemon was not found"; end
           return 1
        end
    end

    function _emacs_has_visible_frames
        # no point in asking the server how many frames if it isn't
        # running, now is it?
        if _is_emacs_server_running
            # the server has one frame (called 'F1') but it isn't really a
            # visible frame.  We want to have two or more visible frames to
            # say that there are any visible. Note that terminal frames are
            # still frames
            set -l num_frames ($emacs_client -a "" -e '(length(visible-frame-list))')
            if set -q $DEBUG; echo "DEBUG: client says there are $num_frames frames"; end
            return (test $num_frames -ge 2)
        else
            if set -q $DEBUG; echo "DEBUG: the server is not running, so no frames"; end
            return 1
        end
    end

    function _read_stdin
        set TMP (mktemp "/tmp/emacsstdin-XXX")
        /usr/bin/cat - > $TMP # use actual cat, not the bat tool
        if set -q $DEBUG
            if test -e $TEMP
                echo "DEBUG: $TMP was created"
            end
        end
        set -a additional_options "--eval"
        set -a additional_options "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"$TMP\") (delete-file \"$TMP\"))"
    end

    function _spawn_new_frame
        set -a emacs_options "-c"
    end

    # ok, done setting up the scaffolding, we can start
    ## the actual function now
    if test $argv[1] = '-'
        echo $argv
        if set -q $DEBUG; echo "DEBUG: caught the '-' option, read from stdin"; end
        _read_stdin
    else
        getopts $argv | while read -l key value
            if set -q $DEBUG; echo "DEBUG: option $key is $value"; end
            switch $key
                case h help
                    # if help is requested, then nothing else matters
                    # call the help function and quit edt
                    _show_edt_help
                    return 0
                case r replace
                    # it's a default of the underlying emacsclient so
                    # there shouldn't be anything to do here right?
                    if set -q $DEBUG; echo "DEBUG: replace set use current frame"; end
                case n new-window
                    _spawn_new_frame
                case t tty
                    set use_gui 1
                case '*'
                    if set -q $DEBUG; echo "DEBUG: catching non-option $key"; end
                    echo "$key is not a valid option"
            end
            # getopts sets the value of the key to the builtin 'true'
            # if there is no value set.  This is good, except if I want to do
            # something like 'edt -r blah.c'.  Although we pick up the replace
            # option, it get's set to blah.c, and I want to add that to the list
            # but 'edt -r' sets r's value to true, and I don't want to add that
            # to the list.
            if not test $value = true
                if set -q $DEBUG; echo "DEBUG: $key value is $value, adding it"; end
                set -a additional_options $value
            end
        end
    end


    if _is_emacs_server_running
        if set -q $DEBUG; echo "DEBUG: yes, the server is running"; end
    else
        if set -q $DEBUG; echo "DEBUG: no, the server is not running"; end
        # setting alternate editor to the empty string tells
        # emacsclient to start the server then connect
        set -p emacs_options "-a" ""
    end

    if _emacs_has_visible_frames
        if set -q $DEBUG; echo "DEBUG: yes, there are frames open"; end
    else
        if set -q $DEBUG; echo "DEBUG: no frames exist to replace"; end
        _spawn_new_frame
    end

    if set -q $use_gui
        # we aren't using the terminal so return immediately.
        # so we dont need an '&' at the end
        if set -q $DEBUG; echo "DEBUG: return immediately if using the gui"; end
        set -a emacs_options "-n"
    else
        if set -q $DEBUG; echo "DEBUG: not using the gui"; end
        set -a emacs_options "-t"
    end

    if set -q $DEBUG;
        echo -n "DEBUG:"
        echo $emacs_client $emacs_options $additional_options
    end
    # finally, here we run our curated command line
    command $emacs_client $emacs_options $additional_options

    return 0
end
