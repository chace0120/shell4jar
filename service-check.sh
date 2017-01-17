#!/bin/sh

source /etc/profile

CK_LOG=/www/service_check.log

for i in {0..1}
do
  if [ $i == 0 ] 
  then
    app_location=/www/serviceA.jar
    app_name=serviceA
    opt_xmx='-Xmx512m'
    opt_xms='-Xms512m'
  elif [ $i == 1 ]
  then
    app_location=/www/serviceB.jar
    app_name=serviceB
    opt_xmx='-Xmx512m'
    opt_xms='-Xms512m'
  fi

  tpid=`ps -ef|grep $app_name|grep -v grep|grep -v kill|awk '{print $2}'`
  if [ ! ${tpid} ] 
  then
    curdatetime=$(date '+%Y-%m-%d %T')
    echo '====== Service Check Time: '${curdatetime} >> $CK_LOG
    echo ${app_name}' is not running.' >> $CK_LOG
    echo 'try to restart '${app_name}' ...' >> $CK_LOG
    nohup java $opt_xmx $opt_xms -jar $app_location >/dev/null 2>&1 &
    tpid=`ps -ef|grep $app_name|grep -v grep|grep -v kill|awk '{print $2}'`
    if [ ${tpid} ]; then
      echo 'restart '${app_name}' success!' >> $CK_LOG
    else
      echo 'restart '${app_name}' error!' >> $CK_LOG 
    fi
  fi
done


