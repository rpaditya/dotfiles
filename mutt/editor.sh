#!/bin/sh
#
# recent emacsclient will spawn in the current terminal

emacsclient -nw -a ~/.mutt/alteditor.sh "$@"

#if [ "$STY" != "" ]
#then
# screen -X select 3
# emacsclient -a ~/.mutt/alteditor.sh "$@"
# screen -X other
#else
# emacsclient -nw -a ~/.mutt/alteditor.sh "$@"
#fi
