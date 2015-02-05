#!/bin/sh

if [ "$STY" != "" ]
then
# screen -X select 3
 emacsclient -nw -a ~/.mutt/alteditor.sh "$@"
# screen -X other
else
 emacsclient -nw -a ~/.mutt/alteditor.sh "$@"
# emacsclient -a ~/.mutt/alteditor.sh "$@"
fi

#screen -X select 3
#emacsclient -a ~/.mutt/alteditor.sh "$@"
#screen -X other
