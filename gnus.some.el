(setq user-full-name "R.P. (Adi) Aditya")
(setq user-mail-address "aditya@grot.org")
(setq gnus-ignored-from-addresses "aditya@grot.org")

(require 'bbdb)
(bbdb-initialize 'message 'gnus 'sc)
(bbdb-insinuate-message)
(setq bbdb-file "~/.emacs.d/bbdb")           ;; keep ~/ clean; set before loading
;;Tell bbdb about your email address:
(setq bbdb-user-mail-names
      (regexp-opt '("aditya@grot.org")))

(setq gnus-score-find-score-files-function
      '(gnus-score-find-bnews bbdb/gnus-score))

;(setq bbdb/mail-auto-create-p 'bbdb-prune-not-to-me)
;(setq bbdb/news-auto-create-p 'bbdb-prune-not-to-me)
;(setq bbdb/message-auto-create-p 'bbdb-prune-not-to-me)

;; (setq bbdb-ignore-some-messages-alist (quote (("From" . "yammer.com") ("Reply-To" . "yammer.com") ("To" . "yammer.com"))))
(setq bbdb/mail-auto-create-p 'bbdb-ignore-some-messages-hook)
(setq bbdb/news-auto-create-p 'bbdb-ignore-some-messages-hook)
(setq bbdb/message-auto-create-p 'bbdb-ignore-some-messages-hook)

(setq 
 bbdb-offer-save 1                        ;; 1 means save-without-asking
    
 bbdb-use-pop-up nil                        ;; allow popups for addresses
 bbdb-electric-p t                        ;; be disposable with SPC
 bbdb-popup-target-lines  nil               ;; very small
    
 bbdb-dwim-net-address-allow-redundancy t ;; always use full name
 bbdb-quiet-about-name-mismatches t

 bbdb-always-add-address t                ;; add new addresses to existing...
                                             ;; ...contacts automatically
 bbdb-canonicalize-redundant-nets-p nil     ;; x@foo.bar.cx => x@bar.cx

 bbdb-completion-type nil                 ;; complete on anything

 bbdb-complete-name-allow-cycling t       ;; cycle through matches
                                             ;; this only works partially

 bbbd-message-caching-enabled t           ;; be fast
 bbdb-use-alternate-names t               ;; use AKA

 bbdb-elided-display t                    ;; single-line addresses

 ;; auto-create addresses from mail
; bbdb/mail-auto-create-p 'bbdb-ignore-some-messages-hook   
; bbdb-ignore-some-messages-alist ;; don't ask about fake addresses
 ;; NOTE: there can be only one entry per header (such as To, From)
 ;; http://flex.ee.uec.ac.jp/texi/bbdb/bbdb_11.html

; '(( "no.?reply\\|DAEMON\\|daemon\\|facebookmail\\|twitter"))
)

(if user-mail-address "aditya@grot.org"
    ((autoload 'sc-cite-original "supercite")
     (bbdb-insinuate-sc)
; comment out the next two lines if you want to
; use the outlook format quoting as defined below rather than supercite
     (add-hook 'mail-citation-hook 'sc-cite-original)
     (setq message-cite-function 'sc-cite-original)
     (setq message-citation-line-format
      "-----------------------
On %a, %b %d %Y, %N wrote:
")
))

(if user-mail-address "raditya@microsoft.com"
;;; outlook style reply block ;;;
;; from http://permalink.gmane.org/gmane.emacs.gnus.general/68510
    ((setq message-citation-line-function 'message-insert-formatted-citation-line)
     (setq message-cite-reply-above t)
     (setq message-yank-prefix ""
	   message-yank-cited-prefix ""
	   message-yank-empty-prefix "")

     ;; If you even want it more Outlook-ish use this:
     (setq message-citation-line-format
      "\
-----Original Message-----
From: %f
Sent: %A, %B %d, %Y %H:%M %Z
")
;;; outlook-style reply block ;;;
))

;;sMTP
(setq smtpmail-smtp-server "localhost")
(setq message-send-mail-real-function 'smtpmail-send-it)

;;gNUS
(setq ntp-connection-timeout 5)
(setq nntp-nov-gap 100)
(setq nntp-record-commands t)


(setq gnus-asynchronous t)
; pre-fetch only unread articles shorter than 100 lines
; from https://www.gnu.org/software/emacs/manual/html_node/gnus/Asynchronous-Fetching.html
(defun my-async-short-unread-p (data)
  "Return non-nil for short, unread articles."
  (and (gnus-data-unread-p data)
       (< (mail-header-lines (gnus-data-header data))
	  100)))
     
(setq gnus-async-prefetch-article-p 'my-async-short-unread-p)

(setq gnus-thread-hide-subtree 1)

; defaults to some -- so kill all non-read groups
(setq gnus-read-active-file 'some)
(setq gnus-check-new-newsgroups 'ask-server)
(setq gnus-save-killed-list nil)
(setq nnmail-resplit-incoming t)

; don't prompt me if there are more than 200 articles to read
; esp in non-expiring, display all newsgroups
(setq gnus-large-newsgroup 'nil)

(setq gnus-select-method 
      '(nntp "news.gmane.org"))

(setq gnus-secondary-select-method
      '(nnmaildir "grot" 
                  (directory "~/Mail/grot")
                  (directory-files nnheader-directory-files-safe) 
                  (get-new-mail nil)))

;(define-key gnus-summary-mode-map "d" 'gnus-summary-mark-as-expirable)
; http://comments.gmane.org/gmane.emacs.gnus.general/82591
(defun gnus-gmail-move-to-trash ()
  (interactive)
  (gnus-summary-move-article nil gmail-trash-newsgroup))

(setq gmail-trash-newsgroup "nnmaildir+grot:Trash")
;(define-key gnus-summary-mode-map "d" 'gnus-move-to-trash)

(setq bbdb-send-mail-style 'gnus)

(setq nnmail-split-inbox "INBOX")
(setq nnmail-crosspost nil
;       nnmail-split-methods 'bbdb/gnus-split-method
;       bbdb/gnus-split-nomatch-function 'nnmail-split-fancy
;       bbdb/gnus-split-myaddr-regexp gnus-ignored-from-addresses
      nnmail-split-methods 'nnmail-split-fancy
       nnmail-split-fancy
       `(| (any "sellbuy@.*" "INBOX.dl")
	   (any "msbike@.*" "bicycle")
	   (any "mssoc@.*" "INBOX.dl")
	   (any "invclub@.*" "finance")
	   (any "homeown@.*" "home")
	   (any ".*@emacswiki.org" "unix")
	   (any "notifications@yammer.com" "yammer")
	   (any gnus-ignored-from-addresses "INBOX")))

;(setq nnmail-split-methods
;       '(
;         ("INBOX.dl" "^To:.*sellbuy@.*")    
;         ("INBOX.dl" "^Cc:.*sellbuy@.*")    
;         ("bicycle" "^(To\\|Cc):.*msbike@.*")
;         ("mssoc" "^(To\\|Cc):.*mssoc@.*")
;         ("yammer" "^To:.*notifications@yammer.com.*")
;         ("finance" "^(To\\|Cc):.*invclub@.*")
;	 ("INBOX" "")
;        ))

(setq gnus-parameters
      '(
	(".*INBOX.*"
         (display . all)
         (expiry-target . never))
	("grot.Starred"
         (display . all)
         (expiry-target . never))
        ("nntp news.gmane.org"
         (posting-style
          (name "R.P. (Adi) Aditya")
          (address "aditya@grot.org")))
	))

(setq gnus-permanently-visible-groups "Starred\\|INBOX$")

;(setq gnus-auto-expirable-newsgroups
;           "INBOX.dl\\|msbike\\|sellbuy\||mssoc\||homeown\||invclub\||yammer")

(setq gnus-total-expirable-newsgroups
          (regexp-opt '("bulk"
			"Spam"
			"auto")))

(defun my-message-mode-setup ()
  (setq make-backup-files nil)
  (auto-fill-mode 1)
  (setq fill-column 72)    ; rfc 1855 for usenet messages
  (abbrev-mode 1)
  (local-set-key "\C-Xk" 'server-edit)
  ;;http://fsinfo.noone.org/~abe/mutt/#emacs
  ;;(mail-text) ;;; Jumps to the beginning of the mail text
  ;; http://emacs-fu.blogspot.com/2009/01/e-mail-with-emacs-using-mutt.html
;  (post-goto-body)
;  (beginning-of-line)
  ;http://www.hollenback.net/index.php/post.el
  ;Put the cursor just where I want it - at the beginning of the body text.
  ;(bbdb-mail-aliases)
  (bbdb-define-all-aliases)
;;  (set-buffer-file-coding-system utf-8-dos)
)

(autoload 'bbdb/gnus-lines-and-from "bbdb-gnus")
(setq gnus-optional-headers 'bbdb/gnus-lines-and-from)

(add-hook 'message-mode-hook 'my-message-mode-setup)

; set the mode-line and summary line date, thread params
(setq-default
 gnus-summary-mode-line-format "Gnus: %p [%A / Sc:%4z] %Z"
 gnus-summary-same-subject ""
 gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
 gnus-thread-sort-functions '(gnus-thread-sort-by-date)
 gnus-sum-thread-tree-false-root ""
 gnus-sum-thread-tree-indent " "
 gnus-sum-thread-tree-root ""
 gnus-sum-thread-tree-single-indent ""
 gnus-sum-thread-tree-vertical "│"
)

;(setq gnus-user-date-format-alist
;          '(((gnus-seconds-today) . "%H:%M")
;            ((+ 86400 (gnus-seconds-today)) . "%m/%d %H:%M")
;            (604800 . "%A %H:%M") ;;that's one week
;            ((gnus-seconds-month) . "%A %d")
;            ((gnus-seconds-year) . "%B %d")
;            (t . "%B %d '%y"))) ;;this one is used when no other does match

;(setq gnus-user-date-format-alist '((t . "%Y-%m-%d %H:%M")))
(setq gnus-user-date-format-alist '((t . "%m/%d %H:%M")))
;(setq gnus-summary-line-format "%O%U%R%z %N %&user-date; [%-15,15f] %B%s\n")
(setq gnus-summary-line-format "%d %U[%-15,15f] %B%s\n")

;; from http://www.xsteve.at/prg/gnus/
;(setq gnus-summary-line-format "%O%U%R%z%d %B%(%[%4L: %-22,22f%]%) %s\n")
;(setq gnus-sum-thread-tree-leaf-with-other "+-> ")
;(setq gnus-sum-thread-tree-single-leaf "`-> ")

; from http://www.emacswiki.org/emacs/GnusFormatting
; Version 3 (Unicode)
;(setq gnus-summary-line-format "%U%R%z %&user-date; %-15,15f  %B%s%)\n")
(setq gnus-sum-thread-tree-leaf-with-other "├► ")
;(setq gnus-sum-thread-tree-single-leaf "╰► ")
(setq gnus-sum-thread-tree-single-leaf "└─▶ ")


(setq message-generate-headers-first t)

(setq message-kill-buffer-on-exit t)

(add-hook 'message-sent-hook 'gnus-score-followup-article)
(add-hook 'message-sent-hook 'gnus-score-followup-thread)

(setq gnus-use-adaptive-scoring t)
(setq gnus-score-expiry-days 14)
(setq gnus-default-adaptive-score-alist
  '((gnus-unread-mark)
    (gnus-ticked-mark (from 4))
    (gnus-dormant-mark (from 5))
    (gnus-saved-mark (from 20) (subject 5))
    (gnus-del-mark (from -2) (subject -5))
    (gnus-read-mark (from 2) (subject 1))
    (gnus-killed-mark (from 0) (subject -3))))
    ;(gnus-killed-mark (from -1) (subject -3))))
    ;(gnus-kill-file-mark (from -9999)))
    ;(gnus-expirable-mark (from -1) (subject -1))
    ;(gnus-ancient-mark (subject -1))
    ;(gnus-low-score-mark (subject -1))
    ;(gnus-catchup-mark (subject -1))))

(setq gnus-score-decay-constant 1) ;default = 3
(setq gnus-score-decay-scale 0.03) ;default = 0.05

(setq gnus-decay-scores t) ;(gnus-decay-score 1000)

(setq gnus-global-score-files
       '("~/gnus/scores/all.SCORE"))

;; all.SCORE contains:
;;(("xref"
;;  ("gmane.spam.detected" -1000 nil s)))
(setq gnus-summary-expunge-below -999)

;(defun message-toggle-gcc ()
;  "Insert or remove the \"Gcc\" header."
;  (interactive)
;  (save-excursion
;    (save-restriction
;      (message-narrow-to-headers)
;      (if (message-fetch-field "Gcc")
;          (message-remove-header "Gcc")
;        (gnus-inews-insert-archive-gcc)))))

;(define-key message-mode-map [(control ?c) (control ?f) (control ?g)] 'message-toggle-gcc)

(setq gnus-directory "~/gnus")
;(setq message-directory "~/gnus/mail")
;(setq nnml-directory "~/gnus/nnml-mail")
(setq gnus-article-save-directory "~/gnus/saved")
(setq gnus-kill-files-directory "~/gnus/scores")
(setq gnus-cache-directory "~/gnus/cache")

(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

(require 'gnus-registry)
(gnus-registry-initialize)

(setq gnus-visible-headers "^From:\\|^Newsgroups:\\|^Subject:\\|^Date:\\|^Followup-To:\\|^Reply-To:\\|^Summary:\\|^Keywords:\\|^To:\\|^[BGF]?Cc:\\|^Posted-To:\\|^Mail-Copies-To:\\|^Mail-Followup-To:\\|^Apparently-To:\\|^Gnus-Warning:\\|^Resent-From:\\|^X-Sent:\\|^User-Agent:\\|^X-Mailer:\\|^X-Newsreader:")

(setq gnus-sorted-header-list '("^From:" "^Subject:" "^Summary:" "^Keywords:" "^Newsgroups:" "^Followup-To:" "^To:" "^Cc:" "^Date:" "^User-Agent:" "^X-Mailer:" "^X-Newsreader:"))

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

(setq spam-directory "~/gnus/spam/")

(setq gnus-spam-process-newsgroups
      '(("^gmane\\."
         ((spam spam-use-gmane)))))

(require 'spam)


; ;; use post mode http://emacs-fu.blogspot.com/2009/01/e-mail-with-emacs-using-mutt.html
; (autoload 'post-mode "post" "mode for e-mail" t)
; (defun my-post-mode-hook ()
;   (setq make-backup-files nil)
;   (auto-fill-mode 1)
;   (setq fill-column 72)    ; rfc 1855 for usenet messages
;   (abbrev-mode 1)
;   (local-set-key "\C-Xk" 'server-edit)
; ;    (require 'footnote-mode)
; ;    (footmode-mode t)
; ;    (require 'boxquote)
; ;http://www.hollenback.net/index.php/post.el
; ;Put the cursor just where I want it - at the beginning of the body
;    ;text.
;    (post-goto-body)
;    (beginning-of-line)
; )
; (add-hook 'post-mode-hook 'my-post-mode-hook)
; ;; End post-mode setup

(defun bbdb-prune-not-to-me ()
  "defun called when bbdb is trying to automatically create a record.
  Filters out anything not actually adressed to me then passes control
to 'bbdb-ignore-some-messages-hook'.  Also filters out anything that
is precedense 'junk' or 'bulk' This code is from Ronan Waide < waider
@ waider . ie >."
  (let ((case-fold-search t)
        (done nil)
        (b (current-buffer))
        (marker (bbdb-header-start))
        field regexp fieldval)
    (set-buffer (marker-buffer marker))
    (save-excursion
      ;; Hey ho. The buffer we're in is the mail file, narrowed to the
      ;; current message.
      (let (to cc precedence)
        (goto-char marker)
        (setq to (bbdb-extract-field-value "To"))
        (goto-char marker)
        (setq cc (bbdb-extract-field-value "Cc"))
        (goto-char marker)
        (setq precedence (bbdb-extract-field-value "Precedence"))
        ;; Here's where you put your email information.
        ;; Basically, you just add all the regexps you want for
        ;; both the 'to' field and the 'cc' field.
        (if (and (not (string-match "aditya@grot.org" (or to "")))
                 (not (string-match "aditya@grot.org" (or cc ""))))
            (progn
              (message "BBDB unfiling; message to: %s cc: %s"
                       (or to "noone") (or cc "noone"))
              ;; Return nil so that the record isn't added.
              nil)

          (if (string-match "junk" (or precedence ""))
              (progn
                (message "precedence set to junk, bbdb ignoring.")
                nil)

            ;; Otherwise add, subject to filtering
            (bbdb-ignore-some-messages-hook)))))))

;; ;(autoload 'wl "wl" "Wanderlust" t)

(require 'w3m)
;(require 'w3m-load)
; from http://www.emacswiki.org/emacs/WThreeMHintsAndTips
(setq w3m-use-cookies t)
(setq browse-url-browser-function 'w3m-browse-url
          browse-url-new-window-flag t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(global-set-key "\C-xm" 'browse-url-at-point)

(defun desktop-buffer-w3m-misc-data ()
  "Save data necessary to restore a `w3m' buffer."
  (when (eq major-mode 'w3m-mode)
    w3m-current-url))

(defun desktop-buffer-w3m ()
 "Restore a `w3m' buffer on `desktop' load."
  (when (eq 'w3m-mode desktop-buffer-major-mode)
    (let ((url desktop-buffer-misc))
      (when url
        (require 'w3m)
        (if (string-match "^file" url)
	    (w3m-find-file (substring url 7))
	  (w3m-goto-url url))
	(current-buffer)))))

;(add-to-list 'desktop-buffer-handlers 'desktop-buffer-w3m)
;(add-to-list 'desktop-buffer-misc-functions 'desktop-buffer-w3m-misc-data)
;(add-to-list 'desktop-buffer-modes-to-save 'w3m-mode)

(require 'url)

(setq gnus-inhibit-startup-message t)


; from http://www.emacswiki.org/emacs/BrowsingUrlsInGnusArticle
(add-hook 'gnus-startup-hook
	  (lambda nil
	    (define-key gnus-summary-mode-map (kbd "C-c C-o")
	      (lambda () (interactive)
		(let ((url
		       (with-current-buffer gnus-article-buffer
			 (let ((msgids (split-string (aref gnus-current-headers 8) "[ :]")))
			   (cond ((and (equal (substring (second msgids) 0 6)
					      "gwene.")
				       (goto-char (point-max))
				       (search-backward "Link" (point-min) 'noerror))
				  (w3m-active-region-or-url-at-point))
				 ((equal (substring (second msgids) 0 6)
					 "gmane.")
				  (concat "http://comments.gmane.org/" (second msgids) "/" (third msgids))))))))
		  (if url
		      (browse-url (message url))
		    (message "Couldn't find any likely url")))))))

(set-face-foreground 'button "black")

(setq gnus-group-highlight
      (append
       '(((and (= unread 0) mailp (eq level 1)) . gnus-group-mail-1-empty-face)
	 ((and              mailp (eq level 1)) . gnus-group-mail-1-face)
	 ((and (= unread 0) mailp (eq level 2)) . gnus-group-mail-2-empty-face)
	 ((and              mailp (eq level 2)) . gnus-group-mail-2-face)
	 ((and (= unread 0) mailp (eq level 3)) . gnus-group-mail-3-empty-face)
	 ((and              mailp (eq level 3)) . gnus-group-mail-3-face)
	 ((and (= unread 0) mailp (eq level 4)) . gnus-group-mail-4-empty-face)
	 ((and              mailp (eq level 4)) . gnus-group-mail-4-face)
	 ((and (= unread 0) mailp) . gnus-group-mail-low-empty-face)
	 ((and              mailp) . gnus-group-mail-low-face))
       gnus-group-highlight))

(copy-face 'default 'gnus-group-mail-4-empty-face)
(copy-face 'bold    'gnus-group-mail-4-face)

(set-face-foreground 'gnus-group-mail-1-face         "black")
(set-face-foreground 'gnus-group-mail-1-empty-face   "color-242")
(set-face-foreground 'gnus-group-mail-2-face         "black")
(set-face-foreground 'gnus-group-mail-2-empty-face   "color-242")
(set-face-foreground 'gnus-group-mail-3-face         "black")
(set-face-foreground 'gnus-group-mail-3-empty-face   "color-242")
(set-face-foreground 'gnus-group-mail-4-face         "black")
(set-face-foreground 'gnus-group-mail-4-empty-face   "color-242")
(set-face-foreground 'gnus-group-mail-low-face       "black")
(set-face-foreground 'gnus-group-mail-low-empty-face "color-242")
(set-face-foreground 'gnus-summary-high-read "black")
(set-face-foreground 'gnus-summary-high-ancient "navy")

(set-face-foreground 'gnus-summary-cancelled "black")
(set-face-foreground 'gnus-summary-high-ancient "black")
(set-face-foreground 'gnus-summary-high-read "black")
(set-face-foreground 'gnus-summary-high-ticked "black")
(set-face-foreground 'gnus-summary-high-undownloaded "black")
(set-face-foreground 'gnus-summary-high-unread "black")
(set-face-foreground 'gnus-summary-low-ancient "black")
(set-face-foreground 'gnus-summary-low-read "black")
(set-face-foreground 'gnus-summary-low-ticked "black")
(set-face-foreground 'gnus-summary-low-undownloaded "black")
(set-face-foreground 'gnus-summary-low-unread "black")
(set-face-foreground 'gnus-summary-normal-ancient "black")
(set-face-foreground 'gnus-summary-normal-read "black")
(set-face-foreground 'gnus-summary-normal-ticked "black")
(set-face-foreground 'gnus-summary-normal-undownloaded "black")
(set-face-foreground 'gnus-summary-normal-unread "black")
(set-face-foreground 'gnus-summary-selected "black")

(set-face-foreground 'gnus-group-news-1 "navy")
(set-face-foreground 'gnus-group-news-1-empty "blue")
(set-face-foreground 'gnus-group-news-2 "navy")
(set-face-foreground 'gnus-group-news-2-empty "blue")
(set-face-foreground 'gnus-group-news-low "navy")
(set-face-foreground 'gnus-group-news-low-empty "blue")

;(set-face-foreground 'gnus-server-agent "black")
;(set-face-foreground 'gnus-server-closed "black")
;(set-face-foreground 'gnus-server-denied "black")
;(set-face-foreground 'gnus-server-offline "black")
;(set-face-foreground 'gnus-server-opened "black")

(set-face-foreground 'gnus-header-content "navy")
(set-face-foreground 'gnus-header-subject "black")
(set-face-foreground 'gnus-header-from "navy")
(set-face-foreground 'gnus-header-name "navy")
(set-face-foreground 'gnus-header-newsgroups "navy")

;; message mode

(set-face-foreground 'message-header-cc "navy")
(set-face-foreground 'message-header-name "navy")
(set-face-foreground 'message-header-newsgroups "navy")
(set-face-foreground 'message-header-subject "black")
(set-face-foreground 'message-header-to "black")
(set-face-foreground 'message-header-xheader "navy")
(set-face-foreground 'message-header-other "nvay")
(set-face-foreground 'message-cited-text "navy")
(set-face-foreground 'message-separator "blue")

