;; -*- mode: lisp -*-

(require 'cl)

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/site-lisp")
;; (add-to-list 'load-path "~/.emacs.d")
;; (require 'vc-svn)
;; (add-to-list 'vc-handled-backends `SVN)
;; (require 'vc-git)
;; (add-to-list 'vc-handled-backends `GIT)

;; Are we running XEmacs or Emacs?
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;;don't use backslash for line wrap indicators as it breaks copying urls
;; https://www.emacswiki.org/emacs/LineWrap - "Line Wrap character"
;;
(set-display-table-slot standard-display-table 'wrap ?\ )

;; Reverse screen's reverse of C-h
;(keyboard-translate ?\C-h ?\C-?)
;(keyboard-translate ?\C-? ?\C-h)
; or not
;(keyboard-translate ?\C-h ?\C-h)
;(keyboard-translate ?\C-? ?\C-?)

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)
(global-set-key [(control h)] 'delete-backward-char)

(global-set-key "\eg" 'goto-line)

;; Turn on font-lock mode for Emacs
(cond ((not running-xemacs)
       (global-font-lock-mode t)
       (menu-bar-mode -1)
))

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; Enable wheelmouse support by default
(if (not running-xemacs)
	(require 'mwheel) ; Emacs
	(mwheel-install) ; XEmacs
)

(setq paren-mode 'paren)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;from http://www.emacswiki.org/emacs/AutoFillMode
;; we already do this in my-mail-mode-hook
;;(add-hook 'mail-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;;(setq-default show-trailing-whitespace t)
;;(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'c-mode-common-hook
              (lambda ()
                (auto-fill-mode 1)
                (set (make-local-variable 'fill-nobreak-predicate)
                     (lambda ()
                       (not (eq (get-text-property (point) 'face)
                                'font-lock-comment-face))))))
(global-set-key (kbd "C-c q") 'auto-fill-mode)

;(add-hook 'message-mode-hook
;          'turn-on-auto-fill
;          (function
;           (lambda ()
;             (progn
;               (local-unset-key "\C-c\C-c")
;               (define-key message-mode-map "\C-c\C-c" '(lambda ()
;                                                          "save and exit quick;ly"
;                                                          (interactive)
;                                                          (save-buffer)
;                                                          (server-edit)))))))


; not in package.el
;; XSL mode
;(autoload 'xsl-mode "xslide" "Major mode for XSL stylesheets." t)

(setq auto-mode-alist
      (append
       (list
        '(".*w3m form textarea.*" . wikipedia-mode)
        '("\\.wiki" . wikipedia-mode)
        '("w3mtmp.*" . wikipedia-mode)
        '("\\.jsp" . jsp-mode)
        '("\\.fo" . xsl-mode)
        '("\\.gra\\'" . lisp-mode)
        ;; edit mutt and news messages in mail mode
        '("/tmp/mutt-\\|.article\\|\\.followup" . message-mode)
        '("\\.xsl" . xml-mode))
       auto-mode-alist))

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; http://stackoverflow.com/questions/12492/pretty-printing-xml-files-on-emacs
(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

; use --daemon on command line instead so we have a separate one for GNUs
(server-start)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(send-mail-function (quote smtpmail-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
