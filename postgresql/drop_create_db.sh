#!/usr/bin/env sh
# Created by elexis-uitest/dbSpec/pom.xml as /home/niklaus/medelexis-uitest/postgresql/../postgresql/drop_create_db.sh
export PGPASSWORD=elexisTest
/usr/bin/env psql --host=localhost --user=elexis --command="drop database if exists elexis_rcptt_de;"
/usr/bin/env psql --host=localhost --user=elexis --command="create database elexis_rcptt_de encoding 'utf8' template template0;"
