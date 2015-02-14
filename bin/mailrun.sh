#!/usr/bin/env bash


cleanup() {
    /usr/bin/sqlite3 ~/.offlineimap/Account-mswork/LocalStatus-sqlite/INBOX 'pragma integrity_check;'
}

# Check every ten seconds if the process identified as $1 is still 
# running. After 5 checks (~60 seconds), kill it. Return non-zero to 
# indicate something was killed.
monitor() {
  local pid=$1 i=0

  while ps $pid &>/dev/null; do
    if (( i++ > 12 )); then
      logger -p crit "Max checks reached. Sending SIGKILL to ${pid}..."
#      echo "Max checks reached. Sending SIGKILL to ${pid}..." >&2
      kill -9 $pid; return 1
    fi

    sleep 10
#    cleanup
  done

  return 0
}

read -r pid < ~/.offlineimap/pid

if ps $pid &>/dev/null; then
  logger -p crit "Process ${pid} already running. Exiting..."
#  echo "Process $pid already running. Exiting..." >&2
  exit 1
fi

logger -p info "Starting offlineimap"
out=`offlineimap -o -u quiet & monitor $!`
logger -p info "${out}"
#if [ $? -ne 0 ]; then
#    cleanup
#fi
logger -p info "end of mailrun.sh/offlineimap script"

