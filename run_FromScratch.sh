#!/bin/bash -v
logger "cron: $0 started"
cd `dirname $0`
xvfb-run -a --server-args="-screen 0 1280x1024x24" mvn -V clean verify  -f RunFromScratch/pom.xml -Dsuite2run=SmokeTestSuite  2>&1 | tee `basename --suffix=.sh $0`.log
