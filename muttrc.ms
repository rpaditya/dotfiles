source "~/.mutt/common"

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
