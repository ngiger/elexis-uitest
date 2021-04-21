#!/usr/bin/env bash
logger "cron: $0 started"
cd `dirname $0`
rm -rfv ~/elexis/rcptt
xvfb-run -a openbox --startup "mvn -V --batch-mode clean install --settings $PWD/mysql/settings.xml -f $PWD/mysql/pom.xml" 2>&1 | tee `basename --suffix=.sh $0`.log
