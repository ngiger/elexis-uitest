#!/usr/bin/env bash
# https://linuxize.com/post/install-java-on-debian-10/
set -o xtrace # enable seeing the commands, prepended with a + sign
export DEBIAN_FRONTEND=noninteractive
sudo userdel --force jenkins_slave
sudo useradd  --shell /usr/bin/fish --uid 1007 -G sudo,lp,users --create-home jenkins_slave
set -e # Do exit on any error:
source /etc/environment
echo $JAVA_HOME
echo -e "elexisTest\nelexisTest\n" | sudo passwd jenkins_slave
# Prepare jenkins_slave
sudo -iHu jenkins_slave <<EOF
rm -f agent.jar
wget -nv https://srv.elexis.info/jenkins/jnlpJars/agent.jar
mkdir -p ~/.ssh ~/slave/remoting ~/slave/workspace
echo 'JS2a78HHzBNm73R6AA5uO8hofjqm2k69mbO3alQZkpUmvXyjXe9CZDaze4arYrL9wnRLaOi5HQ9s4lls9ROOBUo5J6YeHFtmpQ4sMWEs4IrMy+QXlmpNrK97N9GY3nhKYvvP2M5+yUajWx3yuiRF0CqQmu9jbBJFMnHW4XOKD jenkins@srv' | tee --append ~/.ssh/authorized_keys
EOF

sudo apt-get install -qy mariadb-common mysql-common
sudo mkdir -p /etc/mysql/mariadb.conf.d/
echo "[mariadb]" | sudo tee /etc/mysql/mariadb.conf.d/lowercase.cnf
echo "lower_case_table_names=1" | sudo tee --append /etc/mysql/mariadb.conf.d//lowercase.cnf
sudo apt-get install -qy mariadb-server postgresql
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

# taken from postgresql/pom.xml
sudo -u postgres psql <<EOF
  create user elexis with password 'elexisTest';
  create database elexis owner elexis encoding 'utf8' template template0;
  ALTER USER elexis CREATEDB;
  create database elexis_rcptt_de owner elexis encoding 'utf8' template template0;
  GRANT ALL PRIVILEGES ON DATABASE elexis_rcptt_de TO elexis ;
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO elexis;
  ALTER DATABASE elexis_rcptt_de OWNER TO elexis;
  create database elexis_rcptt_fr owner elexis encoding 'utf8' template template0;
  GRANT ALL PRIVILEGES ON DATABASE elexis_rcptt_fr TO elexis ;
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO elexis;
  ALTER DATABASE elexis_rcptt_fr OWNER TO elexis;
EOF

# sudo cp /home/vagrant/scripts/jenkins-slave.service /home/vagrant/scripts/*.conf /etc/systemd/system/
# sudo systemctl daemon-reload
# sudo systemctl enable jenkins-slave
# sudo systemctl start jenkins-slave
# sleep 2
# sudo systemctl status jenkins-slave
