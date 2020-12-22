;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(package-initialize)

(org-babel-load-file "~/.spacemacs.d/config/spacemacs-init.org")
(org-babel-load-file "~/.spacemacs.d/config/spacemacs-user-init.org")
(org-babel-load-file "~/.spacemacs.d/config/spacemacs-layers.org")
(org-babel-load-file "~/.spacemacs.d/config/spacemacs-user-config.org")
(org-babel-load-file "~/.spacemacs.d/config/spacemacs-user-functions.org")

;; > Do not write anything past this comment. This is where Emacs will
;; > auto-generate custom variable definitions.
;; yeah, i know what you said but... i hate the extra cruft in here

(setq custom-file "~/.spacemacs.d/emacs-customs.el")
(load custom-file)
