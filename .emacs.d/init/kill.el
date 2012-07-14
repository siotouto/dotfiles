(eval-when-compile (require 'cl))

;; xsel command
(defun xsel-available-p ()
  (and (executable-find "xsel") (not (string= "" (or (getenv "DISPLAY") "")))))
(defun xsel-input (type text)
 (let* ((process-connection-type nil)
        (type (if (eq type 'PRIMARY) "-p" "-b"))
        (proc (start-process "xsel" "*Messages*" "xsel" type "-i")))
   (process-send-string proc text)
   (process-send-eof proc)))
(defun xsel-output (type)
  (let ((type (if (eq type 'PRIMARY) "-p" "-b")))
    (mapconcat '(lambda (x) x) (process-lines "xsel" type "-o") "\n")))
(defun xsel-clear (type)
 (let ((type (if (eq type 'PRIMARY) "-p" "-b")))
   (call-process "xsel" nil "*Messages*" nil type "-c")))

;; Some applications recognize only PRIMARY section
;; See http://garin.jp/doc/Linux/xwindow_clipboard for details
(setq x-select-enable-primary t)
(setq x-select-enable-clipboard t)

;; yank to X clipboard even if we are in terminal mode Emacs
(defadvice x-select-text (around ad-x-select-text (text) activate)
  (if (or (eq system-type 'windows-nt)
          (featurep 'ns)
          (eq (framep (selected-frame)) 'x)
          (not (xsel-available-p)))
      ad-do-it
    (flet ((framep (frame) 'x))
      (letf (((symbol-function 'x-own-selection-internal)
              (symbol-function 'xsel-input))
             ((symbol-function 'x-disown-selection-internal)
              (symbol-function 'xsel-clear)))
      ad-do-it))))

;; paste from X clipboard even if we are in terminal mode Emacs
(defadvice x-selection-value (around ad-x-selection-value-xsel activate)
  (if (or (eq (framep (selected-frame)) 'x) (not (xsel-available-p)))
      ad-do-it
    (flet ((framep (frame) 'x))
      (letf (((symbol-function 'x-selection-value-internal)
              (symbol-function 'xsel-output)))
        ad-do-it))))
