#!/usr/bin/env bash
# https://linuxize.com/post/install-java-on-debian-10/
# scripts/down_oomph_rcptt must be run before
set -o xtrace # enable seeing the commands, prepended with a + sign
userdel -f niklaus
set -e # Do exit on any error:
export DOWNLOAD_DIR=/opt/downloads
useradd  --shell /usr/bin/fish --uid 1002 -G sudo,lp,users --create-home niklaus
sudo apt install -yq task-german-kde-desktop task-german plasma-desktop neovim plasma-workspace-wayland
echo -e "ng8752\nng8752\n" | sudo passwd niklaus
sudo -iHu niklaus <<EOF
mkdir -p .ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJY7+iMHzZ4v7rfVdmpkMFzxwWwetpj9F/At/bo0OM1i Niklaus Giger Dez 2019" > .ssh/authorized_keys
ls -lrt
unzip -u ${DOWNLOAD_DIR}/rcptt.ide-2.5.1-linux.gtk.x86_64.zip
pwd
ls -lrt
tar -zxf ${DOWNLOAD_DIR}/eclipse-inst-jre-linux64.tar.gz
EOF

sudo -iHu jenkins <<EOF
mkdir -p .ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJY7+iMHzZ4v7rfVdmpkMFzxwWwetpj9F/At/bo0OM1i jenkins Giger Dez 2019" > .ssh/authorized_keys
unzip -u ${DOWNLOAD_DIR}/rcptt.ide-2.5.1-linux.gtk.x86_64.zip
EOF
echo Installing rcptt into niklaus and jenkins was okay
