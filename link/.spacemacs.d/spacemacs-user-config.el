(setq powerline-default-separator 'alternate)

(setq deft-use-filename-as-title t)
;; with this tell deft to use the search
;; term as the filename if a new file is created
(setq deft-use-filter-string-for-filename t)
(setq deft-file-naming-rules
      '((noslash . "-")
        (nospace . "-")
        (case-fn . downcase)))
(setq deft-text-mode 'org-mode)
(setq deft-org-mode-title-prefix t)
(setq deft-directory "~/org/notes")
(setq deft-archive-directory "../.archive/")
(setq deft-extensions '("org"))
(setq deft-default-extension "org")
(setq deft-auto-save-interval 30)

;;(with-eval-after-load 'org

(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook (lambda () (hl-todo-mode -1) nil))

(setq org-todo-keywords '(
        (sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
))
(setq org-todo-keyword-faces (quote (
                      ("TODO" :foreground "brown"      :weight bold)
                      ("NEXT" :foreground "tomato"     :weight bold)
                      ("DONE" :foreground "olive drab" :weight bold)
)))

(setq org-stuck-projects
'(
   ;; the tags-todo search that identifies projects
   "-someday-wait-IGNORE-REVIEW/TODO"
   ;; if these TODO words are found, it is not stuck
   ("NEXT")
   ;; if these tags are found in the subitems, it is not stuck
   nil
   ;; a regular expression that matches non stuck
   ""
  )
 )

(with-eval-after-load 'org
;; Replace org-set-tags with org-set-tags-command in keybinding
(spacemacs/set-leader-keys-for-major-mode 'org-mode ":" 'org-set-tags-command)
)
(setq org-tags-column -120)

(setq org-tag-alist '(
 ;;   Next Action Contexts
      ("comms"    .   ?c)
      ("web"      .   ?w)
      ("cac"      .   ?a)
      ("office"   .   ?o)
      ("home"     .   ?h)
      ("mcen"     .   ?m)
      ("vault"    .   ?v)
      ("imefdm"   .   ?i)
 ;;   Meetings and People
      ("staff"    .   ?t)
      ("spe"      .   ?p)
      ("col"      .   ?C)
 ;;   Categories and flags
      ("someday"  .   ?s)
      ("wait"     .   ?W)
      ("read"     .   ?r)
      ("fifo"     .   ?f)
      ("journal"  .   ?j)
      ("REVIEW"   .   ?R)
      ))

  (setq org-tags-exclude-from-inheritance '(
      "read"
      "REVIEW"
      "someday"
      "wait"
      "fifo"
      "journal"
      ))

(org-clock-persistence-insinuate)
;; the number of clock tasks to remember in history
(setq org-clock-history-length 36)
;;  resume clock when clocking into task with open clock.
;; When clocking into a task with a clock entry which has not been closed,
;; the clock can be resumed from that point
(setq org-clock-in-resume t)
;; when set to t , both the running clock and entire history are saved when
;; emacs closes and resume when emacs restarts
(setq org-clock-persist t)
;; put clock times into LOGBOOK drawer
(setq org-clock-into-drawer t)
;; clock out when the task is marked DONE
(setq org-clock-out-when-done t)

;;;; http://stackoverflow.com/questions/23517372/hook-or-advice-when-aborting-org-capture-before-template-selection

(defadvice org-capture
    (after make-full-window-frame activate)
  "Advise capture to be the only window when used as a popup"
  (if (equal "emacs-capture" (frame-parameter nil 'name))
      (delete-other-windows)))

(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (if (equal "emacs-capture" (frame-parameter nil 'name))
      (delete-frame)))

; set the default directory for some org functionality
(setq org-directory "~/org")
(setq org-agenda-files (file-expand-wildcards "~/org/*.org"))
(setq org-refile-allow-creating-parent-nodes 'confirm)


(defun rebuild-agenda-files ()
  (interactive)
  (load-library "find-lisp")
  (setq org-agenda-files (directory-files "~/org" t "\.org$"))
  (setq org-agenda-text-search-extra-files
        (append
         (find-lisp-find-files "~/org/notes"     "\.org$")
         )
        )
  (setq tra:all-org-files
        (append
         org-agenda-files
         org-agenda-text-search-extra-files)
        )
  (setq org-refile-targets
        (quote ((nil :maxlevel . 5)
                (tra:all-org-files :maxlevel . 5)
        ))
  )
)
(rebuild-agenda-files)

(setq org-agenda-custom-commands
   '(("s" "Stuck Projects"
       ((org-ql-block '(and (not (done))
                            (not (descendants (todo "NEXT")))
                            (not (descendants (todo "TODO")))
                            (not (descendants (scheduled))))
                      ((org-ql-block-header "Stuck Projects")))))))

(setq org-archive-location "~/org/.archive/%s_archive::datetree/")

(setq org-capture-templates
   '(
     ("a" "Appointment" entry
      (file+headline "~/org/calendar.org" "Appointments")
      "* %?\n  %T")
     ("o" "Note" entry
      (file "~/org/review.org" )
      "* %? ")
     ("j" "Journal entry" entry
      (file "~/org/journal.org" )
      "* %<%Y-%m-%d> %? :journal:REVIEW: \n %u"
      :prepend t :clock-in t :clock-resume t)
     ;;; When typing 'w' in firefox
     ;;; |%:description | %^{TITLE} | title of the web-page |
     ;;; |%:link        | %c        | URL                   |
     ;;; |%:initial     | %i        | selected text         |
     ("l" "Web clipping" entry
      (file "~/org/review.org" )
      "* %:description%? :web:\n  %:initial\n  Source :\n %:link"
      :immediate-finish t
      )
     ("c" "capture web clip with note" entry
      (file "~/org/review.org" )
      "* %:description%? :web:\n  %:initial\n  Source :\n %:link"
      )
     ( "t" "Add ticket to database" entry
       (file+headline "~/org/tickets.org" "Backlog")
       "* NEW %?\n%u\n" :prepend t )
     ( "T" "Add ticket to database (with link)" entry
       (file+headline "~/org/tickets.org" "Backlog")
       "* NEW %?\n%u\n\n  Source :\n %F:%(with-current-buffer
         (org-capture-get :original-buffer)
         (number-to-string (line-number-at-pos)))"
       :prepend t )
     ("S" "Add a Song to the list" checkitem
      (file+headline "~/org/lists.org" "Music For Purchase")
      "- [ ] %?"
      )
     )
   )

(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
  (plantuml . t)
  (python . t)
   ))

(setq plantuml-jar-path "/usr/local/bin/plantuml")
(setq org-plantuml-jar-path
  (expand-file-name "/usr/local/bin/plantuml"))

(setq org-completion-use-ido t)
(setq org-refile-targets
 (quote ((org-agenda-files :maxlevel . 7)
                      (nil :maxlevel . 7))))
(setq org-refile-use-outline-path (quote file))

;;)

(defun review ()
  (interactive)
  (find-file "~/org/review.org")
  )

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

(with-eval-after-load 'tracwiki-mode
(tracwiki-define-project "ForwardObserver"
                          "http://trac.timforge.net/ForwardObserver" t))

(setq c-basic-offset 4)
(defconst my-c-style
  '((c-tab-always-indent        . t)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist     . ((substatement-open after)
                                   (brace-list-open)))
    (c-hanging-colons-alist     . ((member-init-intro before)
                                   (inher-intro)
                                   (case-label after)
                                   (label after)
                                   (access-label after)))
    (c-cleanup-list             . (scope-operator
                                   empty-defun-braces
                                   defun-close-semi))
    (c-offsets-alist            . ((arglist-close . c-lineup-arglist)
                                   (substatement-open . 0)
                                   (case-label        . 4)
                                   (block-open        . 0)
                                   (namespace-open    . 0)
                                   (innamespace       . 0)
                                   (knr-argdecl-intro . -)))
    (c-echo-syntactic-information-p . t)
    )
    "My C Programming Style")

 ;; offset customizations not in my-c-style
 (setq c-offsets-alist '((member-init-intro . ++)))

 ;; Customizations for all modes in CC Mode.
 (defun my-c-mode-common-hook ()
  ;; add my personal style and set it for the current buffer
  (c-add-style "PERSONAL" my-c-style t)
  ;; other customizations
  (setq tab-width 4
        ;; this will make sure spaces are used instead of tabs
        indent-tabs-mode nil)
  ;; we like auto-newline and hungry-delete
    (c-toggle-auto-hungry-state 1)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'c++-mode-hook 'my-c-mode-common-hook)
