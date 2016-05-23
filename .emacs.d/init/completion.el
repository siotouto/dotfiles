(bundle tarao-elisp
  ;; shell command (with saving the last command for default value)
  (global-set-key (kbd "M-!") 'shell-command+)
  (global-set-key (kbd "M-|") 'shell-command-on-region+)

  ;; incremental completion in minibuffer
  (yaicomplete-mode))

;; zsh like completion
(setq read-file-name-completion-ignore-case t)
(bundle! zlc :url "http://github.com/mooz/emacs-zlc.git"
  (zlc-mode t)
  (let ((map minibuffer-local-map))
    (define-key map (kbd "C-p") 'zlc-select-previous)
    (define-key map (kbd "C-n") 'zlc-select-next)
    (define-key map (kbd "<up>") 'zlc-select-previous-vertical)
    (define-key map (kbd "<down>") 'zlc-select-next-vertical)
    (define-key map (kbd "C-u") 'backward-kill-path-element)))

;; auto completion like IntelliSense
(bundle! auto-complete
  (global-auto-complete-mode t)
  (setq ac-auto-show-menu 0.5)
  (define-key ac-complete-mode-map (kbd "C-n") 'ac-next)
  (define-key ac-complete-mode-map (kbd "C-p") 'ac-previous)
  (define-key ac-complete-mode-map (kbd "TAB") nil))
