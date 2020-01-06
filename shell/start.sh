#! /bin/bash
if [ $# != 2 ] ; then 
  echo "USAGE: need process name and params" 
  exit 1; 
fi

PROC=$1
PARA=$2
PROCPATH=$(pwd)

#程序崩溃时生成core文件，并且不限制文件大小，修改最大文件描述符
ulimit -c unlimited
ulimit -s unlimited
ulimit -n 10240

#修改core文件名格式和路径
echo '1' > /proc/sys/kernel/core_uses_pid
echo 'core-%e-%s-%t' > /proc/sys/kernel/core_pattern

export LD_LIBRARY_PATH=$PROCPATH/lib:$LD_LIBRARY_PATH

nohup env MALLOC_CHECK_=2 $PROCPATH/$PROC $PARA >/dev/null 2>&1 &

sleep 3

ps aux | grep $PROCPATH/$PROC
