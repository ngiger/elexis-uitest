#!/bin/bash -v
logger "cron: $0 started"
cd `dirname $0`
# other useful definitions are:
# -DautExplicit=/opt/rm/elexis-master/elexis-3-core/ch.elexis.core.p2site/target/products/ch.elexis.core.application.ElexisApp-[classifier].zip
# -Dsuite2run=QuickTestSuite
# -DuseBranch=f11106
xvfb-run -a mvn -V clean install -f postgresql/pom.xml -Dlanguage=fr 2>&1 | tee `basename --suffix=.sh $0`.log
