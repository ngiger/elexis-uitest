#!/usr/bin/env bash
set +v
logger "cron: $0 started"
cd `dirname $0`
# other useful definitions are:
# -DautExplicit=/opt/rm/elexis-master/elexis-3-core/ch.elexis.core.p2site/target/products/ch.elexis.core.application.ElexisApp-[classifier].zip
# -Dsuite2run=QuickTestSuite
# -DuseBranch=f11106
xvfb-run -a openbox --startup "mvn -V --batch-mode clean install --settings $PWD/h2/settings.xml -f $PWD/postgresql/pom.xml -Dlanguage=it" 2>&1 | tee `basename --suffix=.sh $0`.log
  
