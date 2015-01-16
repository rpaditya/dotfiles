;; -*- mode: lisp -*-

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; Always end a file with a newline
(setq require-final-newline t)

;; don't make .~ backup files
(setq make-backup-files nil)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; Reverse screen's reverse of C-h
(setq paren-mode 'paren)
(keyboard-translate ?\C-h ?\C-?)
(keyboard-translate ?\C-? ?\C-h)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(defun terminal-init-screen ()
      "Terminal initialization function for screen-256color."
      (load "term/xterm")
      (xterm-register-default-colors)
      (tty-set-up-initial-frame-faces))

(defalias 'perl-mode 'cperl-mode)
;; http://stackoverflow.com/questions/270772/can-i-use-cperl-mode-with-perl-mode-colorization
(custom-set-faces
 '(cperl-array-face ((t (:weight normal))))
 '(cperl-hash-face ((t (:weight normal))))
)

(menu-bar-mode nil)
(global-font-lock-mode t)
(cond ((fboundp 'global-font-lock-mode)
       ;; Turn on font-lock in all modes that support it
       ;(toggle-global-lazy-font-lock-mode)
       ;; Maximum colors NOT
       (setq font-lock-maximum-decoration nil)))

(custom-set-faces
 '(diff-added ((t (:foreground "blue"))) 'now)
 '(diff-removed ((t (:foreground "Red"))) 'now)
 )

(setq vc-diff-switches "-b")

(server-start)
