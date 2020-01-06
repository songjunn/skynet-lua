#! /bin/bash
if [ $# != 1 ] ; then
  echo "USAGE: need process name and params"
  exit 1;
fi

PROC=$1
PROCPATH=$(pwd)

signo="-15"

fullpath=$PROCPATH/$PROC
srvpid=$(ps aux | grep -v "grep" | grep ${fullpath} | awk '{print $2}')
if [ "${srvpid}" != "" ]
then
  kill $signo ${srvpid}
  text="kill $signo ${fullpath}:${srvpid} ..."
else
  text="${fullpath} is not Running ..."
fi

echo -e '\033[0;31;1m'${text}'\033[0m'

sleep 3

ps aux | grep ${fullpath}
