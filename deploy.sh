#!/bin/sh
# description: script for deploy projects

DATE_TIME_NOW=$(date '+%Y-%m-%d %T')
DEPLOY_LOG=/www/deploy.log

declare -A map=(["basic-manage.jar"]="erp_basic" \
	["contract-manage.jar"]="erp_contract" \
	["customer-manage.jar"]="erp_customer" \
	["document-manage.jar"]="erp_document" \
	["logbook-manage.jar"]="erp_logbook" \
	["ratelog-manage.jar"]="erp_ratelog" \
	["transportation-manage.jar"]="erp_transportation" \
	["ratelog-htls-src.jar"]="erp_ratelog_htls_src" \
	["gocanvas-manage.jar"]="erp_gocanvas" \
	["monthly-report-manage.jar"]="erp_report" \
	["new-duty-manage.jar"]="erp_new_duty" \
	["salesreport-manage.jar"]="erp_sales")

cd /www
echo '******** Deploy Projects Time: '${DATE_TIME_NOW} | tee -a $DEPLOY_LOG
if test -e update.zip 
then 
	unzip update.zip

	# deploy projects of service 
	JAR_FILES_NUM=$(ls *.jar 2>/dev/null | wc -l)
	if [ $JAR_FILES_NUM != "0" ]
	then 
	  chmod 500 *.jar
	  cd services/
	  # get names of jars
	  for FILE_PATH in ../*.jar 
	  do
	    FILE_NAME=${FILE_PATH#*"../"}
	    mv ./$FILE_NAME ../last_services/ && mv ../$FILE_NAME ./
	    echo '====== Service: '${map[$FILE_NAME]}' restart' | tee -a $DEPLOY_LOG
	    service ${map[$FILE_NAME]} restart | tee -a $DEPLOY_LOG
	  done
	fi

	# deploy projects of front
	cd /www
	if test -d employee/ 
	then
	  if test -e employee.zip 
	  then
	    echo '====== The employee/ is updated' | tee -a $DEPLOY_LOG
	    rm -rf last_employee/ && mv employee/ last_employee/ && unzip employee.zip && rm -rf employee.zip
	  fi
	else 
	  echo '====== The employee/ is not found' | tee -a $DEPLOY_LOG
	fi

	if test -d master/
	then
	  if test -e master.zip 
	  then
	    echo '====== The master/ is updated' | tee -a $DEPLOY_LOG
	    rm -rf last_master/ && mv master/ last_master/ && unzip master.zip && rm -rf master.zip
	  fi
	else
	  echo '====== The master/ is not found' | tee -a $DEPLOY_LOG
	fi

	# clear update zip
	rm -rf update.zip
else 
	echo '====== The update.zip is not found' | tee -a $DEPLOY_LOG	
fi