#!/usr/bin/env bash
logger "cron: $0 started"
cd `dirname $0`
# other useful definitions are:
# -Daut=elexis-master/target/products/Elexis-[classifier].zip
# -Dsuite2run=QuickTestSuite
# -DuseBranch=3.12
export XX=`pwd`
echo bin in $XX
set -v
xvfb-run -a openbox --startup "mvn -V --batch-mode clean install --settings=$XX/postgresql/settings.xml -f $XX/postgresql/pom.xml" 2>&1 | tee `basename --suffix=.sh $0`.log;
echo done
killall -9 openbox
#openbox --exit
