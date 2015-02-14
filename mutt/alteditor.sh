#!/bin/sh

if [ "$STY" != "" ]
then
  screen -X select 2
fi

jove "$@"

#screen -X select 2
