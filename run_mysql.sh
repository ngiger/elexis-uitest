#!/bin/bash -v
logger "cron: $0 started"
cd `dirname $0`
xvfb-run -a openbox --startup "mvn -V clean install -f $PWD/mysql/pom.xml" 2>&1 | tee `basename --suffix=.sh $0`.log
