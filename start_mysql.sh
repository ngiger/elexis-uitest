#!/usr/bin/env bash

os/Elexis3 -vmargs -Duser.language=de -Duser.region=CH -Dfile.encoding=utf-8 -Dch.elexis.dbFlavor=mysql -Dch.elexis.dbSpec=jdbc:mysql://localhost/elexis_rcptt_de?serverTimezone=Europe/Zurich -Dch.elexis.dbUser=elexis -Dch.elexis.dbPw=elexisTest -Dch.elexis.firstMandantName=Mustermann -Dch.elexis.firstMandantPassword=elexisTest -Dch.elexis.firstMandantEmail=mmustermann@elexis.info -Dch.elexis.username=Mustermann -Dch.elexis.password=elexisTest
