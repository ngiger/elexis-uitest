#!/usr/bin/env sh
# Created by elexis-uitest/dbSpec/pom.xml as /home/niklaus/medelexis-uitest/postgresql/../postgresql/drop_create_db.sh
export PGPASSWORD=elexisTest
language=${1:-de}
echo $0: language ${language}
/usr/bin/env psql --host=localhost --user=elexis --command="drop database if exists elexis_rcptt_${language};"
/usr/bin/env psql --host=localhost --user=elexis --command="create database elexis_rcptt_${language} encoding 'utf8' template template0;"
