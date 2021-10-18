#!/usr/bin/env bash
# https://linuxize.com/post/install-java-on-debian-10/
set -o xtrace # enable seeing the commands, prepended with a + sign
set -e # Do exit on any error:
apt-get update
apt install -qy apt-transport-https ca-certificates parted wget dirmngr gnupg software-properties-common
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb
apt update
apt install -qy adoptopenjdk-8-hotspot adoptopenjdk-11-hotspot maven fish htop iotop zip unzip openbox awesome sddm etckeeper nfs-common
java -version
# update-alternatives --config java
# echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' > /etc/environment
source /etc/environment
echo $JAVA_HOME
