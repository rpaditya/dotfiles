#!/usr/bin/env bash

#exec 1> >(logger -p error -t $(basename $0)) 2>&1

# by default we only get the full repo every 6 minutes
# which if the cron job runs every 3 mins, then it is every other time
fulleveryxmins=6
myminarg=$1
if [ $myminarg ] ; then
    fulleveryxmins=$1
fi

cleanup() {
    /usr/bin/sqlite3 ~/.offlineimap/Account-mswork/LocalStatus-sqlite/INBOX 'pragma integrity_check;'
}

# Check every ten seconds if the process identified as $1 is still 
# running. After 5 checks (~60 seconds), kill it. Return non-zero to 
# indicate something was killed.
monitor() {
  local pid=$1 i=0

  while ps $pid &>/dev/null; do
    # wait for at least as many minutes as we expect a run instead of a fixed amount
    if (( i++ > ${fulleveryxmins} )); then
      logger -p crit "$USER mailrun Max checks reached. Sending SIGKILL to ${pid}..."
#      echo "Max checks reached. Sending SIGKILL to ${pid}..." >&2
      kill -9 $pid; return 1
    fi

    # wait for up to a minute instead of just 10 seconds now that we get large archives
    sleep 59
#    cleanup
  done

  return 0
}

read -r pid < ~/.offlineimap/pid

if ps $pid &>/dev/null; then
  logger -p crit "$USER mailrun Process ${pid} already running. Exiting..."
#  echo "Process $pid already running. Exiting..." >&2
  exit 1
fi

repo=mswork
verbosity=quiet

if [ $USER == 'aditya' ] ; then
    repo=gmail-grot
fi

#every fulleveryxmins mins get the full repository, otherwise only the INBOX and moc
if [ $(( 10#$(date +%M) % ${fulleveryxmins} )) -eq 0 ] ; then
    folders=""
else
    if [ $repo == 'mswork' ] ; then
	folders="-f INBOX,moc"
    else
	folders="-f INBOX"
    fi
fi

logger -p info -t ${USER}-imap "[${$}] start ${repo} ${folders}"

`offlineimap -o -u ${verbosity} -q -a ${repo} ${folders}| sed -e 's/\; skipping it. Please see FAQ and manual on how to handle this.//g' | sed -e 's/\;//g' | logger -t ${USER}-imap -p error` & monitor $!

logger -p info -t ${USER}-imap "[${$}] end"
