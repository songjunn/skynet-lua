#! /bin/bash
if [ $# != 1 ] ; then
  echo "USAGE: need process name and params"
  exit 1;
fi

PROC=$1
PROCPATH=$(pwd)

ps aux | grep $PROCPATH/$PROC
