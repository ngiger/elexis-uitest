#!/usr/bin/env bash
# https://linuxize.com/post/install-java-on-debian-10/
set -o xtrace # enable seeing the commands, prepended with a + sign
sudo useradd  --shell /usr/bin/fish --uid 1004 -G sudo,lp,users --create-home jenkins
set -e # Do exit on any error:
source /etc/environment
echo $JAVA_HOME
echo -e "elexisTest\nelexisTest\n" | sudo passwd jenkins
sudo -iHu jenkins <<EOF
set -o xtrace # enable seeing the commands, prepended with a + sign
mkdir .ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJY7+iMHzZ4v7rfVdmpkMFzxwWwetpj9F/At/bo0OM1i jenkins Giger Dez 2019" > .ssh/authorized_keys
unzip /home/jenkins/rcptt.ide-2.5.1-linux.gtk.x86_64.zip
pwd
ls -lrt
tar -zxvf /home/jenkins/eclipse-inst-jre-linux64.tar.gz
EOF
sudo cp /home/vagrant/scripts/jenkins-slave.service /home/vagrant/scripts/*.conf /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable jenkins-slave
sudo systemctl start jenkins-slave
sudo apt install libreoffice-writer imagemagick xvfb
wget https://netcologne.dl.sourceforge.net/project/openofficeorg.mirror/4.1.9/binaries/de/
Apache_OpenOffice_4.1.9_Linux_x86-64_install-deb_de.tar.gz
tar -zxf Apache_OpenOffice_4.1.9_Linux_x86-64_install-deb_de.tar.gz
sudo dpkg -i de/DEBS/*.deb
sudo apt install -y firefox-esr-l10n-de konsole xterm okular postgresql mariadb-server mariadb-client

sudo -u postgres psql
