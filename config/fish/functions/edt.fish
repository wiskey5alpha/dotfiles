
function edt -d "run the emacsclient"
    ##  a wrapper around the emacsclient with lots of options.

    # TODO: I want to make this easier by hiding all the other options
    #       behind these function options {{{
    # - n :: open an new gui frame (default)
    # - c :: open in an active gui frame
    # - t :: open in terminal
    # - :: connect to stdin
    # load any files that were passed in
    #
    # with a '-', pipe stdin to emacs
    # if there are any other options send them to the client unchanged
    #
    # }}}

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

    set -l emacs "/usr/bin/emacsclient"
    set -l emacs_options  -a '""'   # make sure to start the server if not already
    set -l is_running     0       # assume it is not running until tested
    set -l use_terminal   0       # assume we want to use the gui

    # check if emacs server is already running
    if pgrep -U (id -u) -f 'emacs --daemon' > /dev/null
        set $is_running 1
    end

    # We'll need the '-c' if the server isnt running already
    if test $is_running -eq 1
        set -a emacs_options "-c"
    end

    # There are arguments passed in, process those ...
    if test (count $argv) -gt 0
        for arg in $argv
            switch $arg
                case "-nw" "-t" "-tty"
                    # looking to stay in the terminal
                    set -a emacs_options $arg
                    set use_terminal 1
                case "-"
                    # passing something in on stdin for emacs to handle
                    set TMP (mktemp "/tmp/emacsstdin-XXX")
                    cat - > $TMP
                    set -a emacs_options "--eval"
                    set -a emacs_options "\"(let ((b (generate-new-buffer \"*stdin*\")))"
                    set -a emacs_options "(switch-to-buffer b) (insert-file-contents \"'$TMP'\")"
                    set -a emacs_options "(delete-file \"'$TMP'\"))')\""
                case "*"
                    # its either one of the lesser used options, or filenames now
                    # or maybe it's -c and we want a new window
                    set -a emacs_options $arg
            end
        end
    end
    if test $use_terminal -eq 0
        # we aren't using the terminal so return immediately.
        # so we dont need an '&' at the end
        set -a emacs_options "-n"
    end
    ##    echo $emacs $emacs_options
    command $emacs $emacs_options
end
