;; hostname
(defconst short-hostname (or (nth 0 (split-string (system-name) "\\."))
                             (system-name))
  "Host part of function `system-name'.")

;; shell
(setq-default explicit-shell-file-name "zsh")
(setq shell-file-name "zsh"
      shell-command-switch "-c"
      max-lisp-eval-depth 50000
      max-specpdl-size 5000)

;; interactive
(fset 'yes-or-no-p 'y-or-n-p)
