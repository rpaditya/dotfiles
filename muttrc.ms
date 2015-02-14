source "~/.mutt/common"

#override what is in the common file
# show html by default in MS emails
alternative_order text/html text/plain text/enriched image/* text

set from = raditya@microsoft.com
set imap_user="raditya@microsoft.com"
set my_domain="microsoft.com"

set mbox_type = Maildir
##set spoolfile = ~/Maildir

set spoolfile = ~/Mail/ms/INBOX
set postponed = ~/Mail/ms/Drats

set folder="$HOME/Mail/ms"      # Local mailboxes stored here
folder-hook . 'set folder=$HOME/Mail/ms'
set record="$HOME/Mail/ms/Sent Items"

# copy all the emails from the Maildir into the current inbox
macro index i "<change-folder>~/Maildir<enter><tag-pattern>.<enter><tag-prefix-cond><save-message>+INBOX<enter><end-cond><change-folder>+INBOX<enter>"
