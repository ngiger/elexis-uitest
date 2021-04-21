#!/usr/bin/env bash
logger "cron: $0 started"
cd `dirname $0`
xvfb-run -a --server-args="-screen 0 1280x1024x24" mvn -V --batch-mode clean verify  -f RunFromScratch/pom.xml -Dsuite2run=QuickTestSuite  2>&1 | tee `basename --suffix=.sh $0`.log
