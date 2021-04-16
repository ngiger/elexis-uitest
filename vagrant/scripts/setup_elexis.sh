#!/usr/bin/env bash
# https://linuxize.com/post/install-java-on-debian-10/
set -o xtrace # enable seeing the commands, prepended with a + sign
sudo userdel --force jenkins
sudo useradd  --shell /usr/bin/fish --uid 1004 -G sudo,lp,users --create-home jenkins
set -e # Do exit on any error:
source /etc/environment
echo $JAVA_HOME
echo -e "elexisTest\nelexisTest\n" | sudo passwd jenkins
sudo -iHu jenkins <<EOF
unzip -u /home/jenkins/rcptt.ide-2.5.1-linux.gtk.x86_64.zip
pwd
ls -lrt
tar -zxf /home/jenkins/eclipse-inst-jre-linux64.tar.gz
EOF
sudo cp /home/vagrant/scripts/jenkins-slave.service /home/vagrant/scripts/*.conf /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable jenkins-slave
sudo systemctl start jenkins-slave
sudo apt install -qy libreoffice-writer imagemagick xvfb
tar -zxf /home/jenkins/Apache_OpenOffice_4.1.9_Linux_x86-64_install-deb_de.tar.gz
sudo dpkg -i de/DEBS/*.deb
sudo apt install -qy firefox-esr-l10n-de konsole xterm okular postgresql mariadb-server mariadb-client
# taken from postgresql/pom.xml 
sudo -u postgres psql <<EOF
  create user elexis with password 'elexisTest';
  create database elexis owner elexis encoding 'utf8' template template0;
  ALTER USER elexis CREATEDB;
  create database elexis_rcptt_de owner elexis encoding 'utf8' template template0;
  GRANT ALL PRIVILEGES ON DATABASE elexis_rcptt_de TO elexis ;
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO elexis;
  ALTER DATABASE elexis_rcptt_de OWNER TO elexis;
EOF
