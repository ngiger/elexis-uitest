#!/usr/bin/env bash
export PGPASSWORD=elexisTest
# echo $0: language ${language}  mysqlHost ${mysqlHost} mysqlPort ${mysqlPort}
/usr/bin/env psql --host=localhost --user=elexis --echo-queries --command="drop database if exists elexis_rcptt_$1;"
/usr/bin/env psql --host=localhost --user=elexis --echo-queries --command="create database elexis_rcptt_$1 encoding 'utf8' template template0;"
