#!/bin/bash -v
logger "cron: $0 started"
cd `dirname $0`
xvfb-run -a mvn -V clean verify  -f RunFromScratch/pom.xml -Dsuite2run=SmokeTestSuite  >> `basename --suffix=.sh $0`.log 2>&1