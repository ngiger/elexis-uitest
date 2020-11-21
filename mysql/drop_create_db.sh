#!/usr/bin/env bash
language=${1:-de}
mysqlHost=${2:-127.0.0.1}
mysqlPort=${3:-3306}
echo $0: language ${language}  mysqlHost ${mysqlHost} mysqlPort ${mysqlPort}
/usr/bin/env mysql --verbose --host=${mysqlHost} --port=${mysqlPort} --user=elexis --password=elexisTest --execute="drop database if exists elexis_rcptt_${language};"
/usr/bin/env mysql --verbose --host=${mysqlHost} --port=${mysqlPort} --user=elexis --password=elexisTest --execute="create database elexis_rcptt_${language};"
