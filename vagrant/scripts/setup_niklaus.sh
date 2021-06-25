#!/usr/bin/env bash
# https://linuxize.com/post/install-java-on-debian-10/
set -o xtrace # enable seeing the commands, prepended with a + sign
set -e # Do exit on any error:
useradd  --shell /usr/bin/fish --uid 1002 -G sudo,lp,users --create-home niklaus
echo -e "ng8752\nng8752\n" | sudo passwd niklaus
sudo -iHu niklaus <<EOF
set -o xtrace # enable seeing the commands, prepended with a + sign
mkdir .ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJY7+iMHzZ4v7rfVdmpkMFzxwWwetpj9F/At/bo0OM1i Niklaus Giger Dez 2019" > .ssh/authorized_keys
wget http://download.eclipse.org/rcptt/release/2.5.1/ide/rcptt.ide-2.5.1-linux.gtk.x86_64.zip
wget https://ftp.snt.utwente.nl/pub/software/eclipse/oomph/products/eclipse-inst-jre-linux64.tar.gz
ls -lrt
unzip rcptt.ide-2.5.1-linux.gtk.x86_64.zip
pwd
ls -lrt
tar -zxvf eclipse-inst-jre-linux64.tar.gz
EOF
