

function todo -d "capture a quick task from the shell"
    set -l output (/usr/bin/emacsclient -a "" --eval "(org-capture-string \"$argv\" \"t\" )")
    printf $output
end
