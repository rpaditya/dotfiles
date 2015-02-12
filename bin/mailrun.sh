#!/bin/sh

PIDFILE=~/.offlineimap/pid

logger -p info "starting mailrun.sh"
read -r pid < ${PIDFILE}

if ! pgrep -F ~/.offlineimap/pid; then
  logger -p crit "Process $pid already running. Exiting..."
  exit 1
else
  logger -p info "running offlineimap"
  offlineimap -o -u quiet
fi

logger -p info "end mailrun.sh"
