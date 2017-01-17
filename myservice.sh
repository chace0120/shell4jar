#!/bin/sh
# chkconfig: 2345 99 10
# description: myservice

source /etc/profile

APP_LOCATION=/www/serviceA.jar
JAVA_OPT="-Xmx512m -Xms512m"
APP_NAME=serviceA

case "$1" in
    start)
	pid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
	if [ ${pid} ]
	then
		echo "$APP_NAME is already running"
	else
		echo "Starting $APP_NAME ..."
		nohup java $JAVA_OPT -jar $APP_LOCATION  > /dev/null 2>&1 & 	 
        fi
        ;;
    stop)
	pid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
        if [ ! ${pid} ]
        then
                echo "$APP_NAME is not running"
        else
		echo "Stoping $APP_NAME ..."
		kill -15 $pid
        fi
	sleep 1
	pid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
	if [ ${pid} ]
	then
		echo "Kill $APP_NAME !";
		kill -9 $pid
	else
		echo "Stop $APP_NAME Success!"
	fi
        ;;
    status)
	pid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
	if [ ${pid} ]
	then
		echo "$APP_NAME is running"
	else
		echo "$APP_NAME is not running"
	fi
	;;
    *)
        echo "Please use start or status or stop as first argument"
        ;;
esac
