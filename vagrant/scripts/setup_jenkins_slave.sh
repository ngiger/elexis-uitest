#!/usr/bin/env bash
# https://linuxize.com/post/install-java-on-debian-10/
set -o xtrace # enable seeing the commands, prepended with a + sign
sudo apt install -qy mariadb-server
sudo userdel --force jenkins_slave
sudo useradd  --shell /usr/bin/fish --uid 1007 -G sudo,lp,users --create-home jenkins_slave
set -e # Do exit on any error:
source /etc/environment
echo $JAVA_HOME
echo -e "elexisTest\nelexisTest\n" | sudo passwd jenkins_slave
sudo -iHu jenkins_slave <<EOF
wget -nv https://srv.elexis.info/jenkins/jnlpJars/agent.jar
EOF

sudo apt install -qy mariadb-common mysql-common
sudo mkdir -p /etc/mysql/mariadb.conf.d/
echo "[mariadb]" | sudo tee /etc/mysql/mariadb.conf.d/lowercase.cnf
echo "lower_case_table_names=1" | sudo tee --append /etc/mysql/mariadb.conf.d//lowercase.cnf
sudo apt install -qy mariadb-server
sudo -u root mysql -e 'SHOW VARIABLES LIKE "%case%";'
sudo -u root mysql -e 'SHOW VARIABLES LIKE "%lower_case_table_names%";' | grep -w 1

# taken from ../../mysql/pom.xmls
sudo -u root mysql <<EOF
    create user if not exists elexis identified by 'elexisTest';
    create database if not exists elexis;
    create database if not exists elexis_rcptt_de;
    create database if not exists elexis_rcptt_fr;
    grant all on elexis_rcptt_de.* to elexis@'%';
    grant all on elexis_rcptt_de.* to 'elexis'@'%' with grant option;
    grant all on elexis_rcptt_fr.* to 'elexis'@'%' with grant option;
    flush privileges;
EOF

sudo cp /home/vagrant/scripts/jenkins-slave.service /home/vagrant/scripts/*.conf /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable jenkins-slave
sudo systemctl start jenkins-slave
sleep 2
sudo systemctl status jenkins-slave
