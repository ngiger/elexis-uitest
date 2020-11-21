#!/usr/bin/env bash
export PGPASSWORD=elexisTest
export language=${1:-de}
# echo $0: language ${language}  mysqlHost ${mysqlHost} mysqlPort ${mysqlPort}
/usr/bin/env psql --host=localhost --user=elexis --echo-queries --command="drop database if exists elexis_rcptt_${language};"
/usr/bin/env psql --host=localhost --user=elexis --echo-queries --command="create database elexis_rcptt_${language} encoding 'utf8' template template0;"
