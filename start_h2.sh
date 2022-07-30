#!/usr/bin/env bash
os-f24209/Elexis3  -nl de_CH -os linux -ws gtk -arch x86_64 -consoleLog -vmargs \
-Duser.language=de -Duser.region=CH -Dfile.encoding=utf-8 \
-Dch.elexis.dbFlavor=h2 -Dch.elexis.dbSpec='jdbc:h2:/home/niklaus/elexis/h2_elexis_rcptt_de/db' \
-Dch.elexis.dbUser=sa -Dch.elexis.dbPw= -Dch.elexis.dbH2AutoServer=1 \
-Dch.elexis.firstMandantName=Mustermann -Dch.elexis.firstMandantPassword=elexisTest -Dch.elexis.firstMandantEmail=mmustermann@elexis.info \
-Dch.elexis.username=Mustermann -Dch.elexis.password=elexisTest -Dch.elexis.test.convertDocx2PDF=true
