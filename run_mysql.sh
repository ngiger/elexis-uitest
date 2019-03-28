#!/bin/bash -v
logger "cron: $0 started"
cd `dirname $0`
xvfb-run -a mvn -V clean install -f mysql/pom.xml 2>&1 | tee `basename --suffix=.sh $0`.log
