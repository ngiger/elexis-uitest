#!/usr/bin/env bash
# https://linuxize.com/post/install-java-on-debian-10/
set -o xtrace # enable seeing the commands, prepended with a + sign
sudo userdel --force jenkins_slave
sudo useradd  --shell /usr/bin/fish --uid 1007 -G sudo,lp,users --create-home jenkins_slave
set -e # Do exit on any error:
source /etc/environment
echo $JAVA_HOME
echo -e "elexisTest\nelexisTest\n" | sudo passwd jenkins_slave
sudo -iHu jenkins_slave <<EOF
wget -nv https://srv.elexis.info/jenkins/jnlpJars/agent.jar
EOF
sudo cp /home/vagrant/scripts/jenkins-slave.service /home/vagrant/scripts/*.conf /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable jenkins-slave
sudo systemctl start jenkins-slave
sleep 2
sudo systemctl status jenkins-slave
