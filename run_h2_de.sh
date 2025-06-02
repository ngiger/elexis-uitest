#!/usr/bin/env bash
logger "cron: $0 started"
cd `dirname $0`
# other useful definitions are:
# -Daut=elexis-master/target/products/Elexis-[classifier].zip
# -Dsuite2run=QuickTestSuite
# -DuseBranch=3.12
export cmd="mvn -V --batch-mode clean install -f $PWD/h2/pom.xml --settings=$PWD/h2/settings.xml -Dlanguage=de"
echo $cmd
# $cmd 2>&1 | tee `basename --suffix=.sh $0`.log
xvfb-run -a openbox --startup "$cmd" 2>&1 | tee `basename --suffix=.sh $0`.log
