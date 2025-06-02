#!/bin/bash -v
logger "cron: $0 started"
cd `dirname $0`
# other useful definitions are:
# -Daut=elexis-master/target/products/Elexis-[classifier].zip
# -Dsuite2run=QuickTestSuite
# -DuseBranch=3.12
xvfb-run -a openbox --startup "mvn -V --batch-mode clean install --settings $PWD/postgresql/settings.xml -f $PWD/postgresql/pom.xml -Dlanguage=fr" 2>&1 | tee `basename --suffix=.sh $0`.log
  
