#!/usr/bin/env bash
logger "cron: $0 started"
cd `dirname $0`
# other useful definitions are:
# -Daut=elexis-master/target/products/Elexis-[classifier].zip
# -Dsuite2run=QuickTestSuite
# -DuseBranch=3.12
set -v
mvn -V --batch-mode clean install --settings=$PWD/postgresql/settings.xml -f $PWD/postgresql/pom.xml -DuseBranch=3.12 2>&1 | tee `basename --suffix=.sh $0`-3.log;
echo done
