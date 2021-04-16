#!/usr/bin/env bash
# https://linuxize.com/post/install-java-on-debian-10/
set -o xtrace # enable seeing the commands, prepended with a + sign
sudo userdel --force jenkins
sudo useradd  --shell /usr/bin/fish --uid 1004 -G sudo,lp,users --create-home jenkins
set -e # Do exit on any error:
echo -e "elexisTest\nelexisTest\n" | sudo passwd jenkins
if test -f /home/jenkins/rcptt.ide-2.5.1-linux.gtk.x86_64.zip
then
  echo RCPTT datei existiert
else
  echo RCPTT datei fehlt
  wget --directory-prefix=/home/jenkins http://download.eclipse.org/rcptt/release/2.5.1/ide/rcptt.ide-2.5.1-linux.gtk.x86_64.zip
fi

if test -f /home/jenkins/eclipse-inst-jre-linux64.tar.gz
then
  echo OOMPH datei existiert
else
  echo OOMPH datei fehlt
  wget --directory-prefix=/home/jenkins https://ftp.snt.utwente.nl/pub/software/eclipse/oomph/products/eclipse-inst-jre-linux64.tar.gz
fi

if test -f /home/jenkins/Apache_OpenOffice_4.1.9_Linux_x86-64_install-deb_de.tar.gz
then
  echo Apache_OpenOffic datei existiert
else
  echo Apache_OpenOffic datei fehlt
  wget  --directory-prefix=/home/jenkins  https://netcologne.dl.sourceforge.net/project/openofficeorg.mirror/4.1.9/binaries/de/Apache_OpenOffice_4.1.9_Linux_x86-64_install-deb_de.tar.gz
fi
