

function org-agenda -d "print the org agenda"
    set -l output (/usr/bin/emacsclient -a "" -e "(message \"%s\" (mapconcat #'substring-no-properties \
        (mapcar #'org-link-display-format \
        (org-agenda-list 1 )))")
   printf $output
end
