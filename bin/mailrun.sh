#!/bin/sh

# Check every ten seconds if the process identified as $1 is still 
# running. After $MAX_CHECKS checks (~60 seconds), kill it. Return non-zero to 
# indicate something was killed.
# 
# Change accordingly
# 
# Too few allowed checks will cause continuous failure on big pulls
MAX_CHECKS=5
# Keep a balance between too long and too short of a sleep. 10 seems good.
SLEEP_TIME=10
#
# Do not modify below if you do not know what you're doing
#
monitor() {
  local pid=$1 i=0

  while ps $pid &>/dev/null; do
    if (( i++ > ${MAX_CHECKS} )); then
      echo "Max checks reached. Sending SIGKILL to ${pid}..." >&2
      kill -9 $pid; return 1
    fi

    sleep 10
  done

  return 0
}

read -r pid < ~/.offlineimap/pid

if ps $pid &>/dev/null; then
  echo "Process $pid already running. Exiting..." >&2
  exit 1
fi

offlineimap -o -u quiet & monitor $!
