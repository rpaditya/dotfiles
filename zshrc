PROMPT='%n@%m[%l]%~%# '

HISTSIZE=10000
SAVEHIST=10000
setopt bang_hist
setopt append_history
setopt extended_history
setopt inc_append_history
setopt share_history
HISTFILE=~/.history
CSH_NULL_GLOB=1
CSH_JUNKIE_HISTORY=1

export EDITOR=~/.mutt/editor.sh
export VISUAL=~/.mutt/editor.sh

# Enhances tab-completion
autoload -U compinit
compinit

path=($path /usr/bin/mh ~/bin)
#export PACKAGESITE=ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/i386/packages-5-stable/Latest/
export PACKAGESITE=ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/i386/packages-stable/Latest/

export TZ=America/Detroit

export SCREENDIR="${HOME}/.screen"
export SSH_AUTH_SOCK="${HOME}/.ssh-agent-screen.groups"

export CVS_RSH="`which ssh`"
#export CVSROOT='five:/usr/local/cvs/'
#export CVSROOT='gocohocvs:/home/cvs/'

#export GIT_DIR="/trunk/grot/git"
#export GIT_WORK_TREE="/usr/admin/aditya"

#export JAVA_OPTS="-server -Xms256m -Xmx256m"
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

CLASSPATH=.
CLASSPATH=$CLASSPATH:$JAVA_HOME/jre/lib/rt.jar
CLASSPATH=$CLASSPATH:$JAVA_HOME/jre/lib/ext/sqljdbc42.jar
#CLASSPATH=$CLASSPATH:/usr/share/java/libreadline-java.jar
#CLASSPATH=$CLASSPATH:/usr/share/java/libreadline-java-0.8.0.1.jar
CLASSPATH=$CLASSPATH:/usr/share/java
CLASSPATH=$CLASSPATH:$HOME/lib/java
#CLASSPATH=$CLASSPATH:$HOME/lib/henplus
#CLASSPATH=$CLASSPATH:$JAVA_HOME/jre/lib/ext/pg74.213.jdbc3.jar
#CLASSPATH=$CLASSPATH:/usr/local/src/java/libreadline-java-0.8.0/libreadline-java.jar
#CLASSPATH=$CLASSPATH:$HOME/lib/henplus/henplus.jar

export CLASSPATH
export NNTPSERVER="news.gmane.org"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# required to make the background default
# as per the section "Using a "default" background does not work." at http://wiki.mutt.org/?MuttFaq/Appearance
export COLORFGBG="default;default"

# a2ps    a2ps --borders=no -B -1
# aa      setenv TZ America/Detroit; date; setenv TZ UTC
# apnic   whois -h whois.apnic.net !*
# arin    whois -h whois.arin.net !*
# bpl     telnet library.berkeley-public.org
# cpan    (perl -MCPAN -e shell)
# glog    gsub -eak aditya@grot.org >>& ~/.glog &
# gsend   gsend -t message/image=http://www.grot.org/aditya.gif
#alias -r inc='incdir -a -i ~/Mail/inbox'
alias -r inc='incdir -a -i /mnt/aditya/tiny.grot.org/Mail/inbox'
# india   setenv TZ Asia/Calcutta; date; setenv TZ UTC
alias -r india='date -u -v+5H -v+30M'
# ls      ls-F
# myfaxsend       sendfax -D -n -d
alias -r new='scan unseen'
#phone 'grep -h -i -A10 !* ~/scratch/doc/adr/address.txt'
phone () { grep -h -i -A10 $1 ~/scratch/doc/adr/address.txt }
# radb    whois -h whois.radb.net !*
# ripe    whois -h whois.ripe.net !*
# rmf     pick -from !* -seq !*; rmm !*
# rmn     rmm; next
# rv      telnet route-views.routeviews.org
# scacc   pick -cc !* -seq !*; scan !*
# scaf    pick -from !* -seq !*; scan !*
# scas    pick -subject !* -seq !*
# scat    pick -to !* -seq !*; scan !*
# showa   showa !* | less
# tasks   grep -h -i -A3 !* ~/.tasks
# tiff2ps tiff2ps -a2z
# tr      /usr/local/sbin/traceroute -Ah whois.radb.net !*
alias -r tr='/usr/sbin/traceroute -n -q 1 '
alias -r tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
# trn     trn -t -T -v -q -x -X

alias -r e='~/.mutt/editor.sh '


# from http://stackoverflow.com/questions/171563/whats-in-your-zshrc
expand-or-complete-with-dots() {
  echo -n "\e[31m......\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

if [[ -r /usr/local/src/shell/z/z.sh ]]
then
 . /usr/local/src/shell/z/z.sh
	function precmd () {
	    _z --add "$(pwd -P)"
	}
fi

# allow ssh completion using ~/ssh/confg targets
# from http://unix.stackexchange.com/questions/52099/how-to-append-extend-zshell-completions
zstyle -s ':completion:*:hosts' hosts _ssh_config
[[ -r ~/.ssh/config ]] && _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p'))
zstyle ':completion:*:hosts' hosts $_ssh_config

if [[ $OS =~ ^Windows ]] 
then
	alias -r ifconfig='ipconfig;netsh interface ipv4 show subinterfaces;netsh interface ipv6 show subinterfaces'
fi

	if [[ -r /usr/local/bin/azure ]]
then
 . <(/usr/local/bin/azure --completion)
fi
