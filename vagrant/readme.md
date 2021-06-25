# Virtual Machines zum Testen von Elexis

Hier findet man alle Dateien, um mit Hilfe von [vagrant](https://www.vagrantup.com/) virtuelle Maschinen einzurichten.

Ich verwende dazu VirtualBox, da ich damit am wenigsten Probleme mit der Tastatur, Fenstern, etc habe.

Folgende Alternativen habe ich verworfen:
* virsh (aka: kvv/qem) mit virt-manager. Aufsetzen ohne grosse Problem. Probleme mit Tastatur
* Gnome-Boxes, verwenden zwar auch virsh, tauchen jedoch im virt-manager nicht auf

## Unter NixOS

nix-env -iA nixos.virtualbox nixos.vagrant
vagrant plugin install vagrant-vbguest
vagrant up

## Konfiguration der Maschinen

Damit die Elexis-Uitest flüssig laufen, sind folgende Parameter gewählt:

* 3 CPUS
* 8 GB RAM # Kann auch etwas kleiner sein, siehe memory Parameter in den Vagrantfile
* 50 GB Diskspace für Windows
* 128 GB Diskspace für Debian



## Voraussetzungen

Vagrant muss installiert sein. Unter Debian buster getestet mit

* sudo apt install vagrant vagrant-sshfs vagrant-hostmanager vagrant-libvirt vagrant-mutate

Wobei nur das erste Paket strikt notwendig ist. Die anderen wurden für Versuche verwendet

Danach kann eine virtuelle Maschine wie folgt hochgefahren werden:

```
cd elexis-windows
vagrant up
```

## Von Hand zu erledigen

* Falls gewünscht anderen Benutzer als Default vagrant mit Passwort vagran anlegen
* Konfiguration von git anpassen, damit via git@github.com/<yourUser> elexis-3-core, etc geklont werden können
* Aufsetzen der gewünschten Datenbank

## TODO

* Konfiguration, dass Java korrekt konfiguriert ist, um ohne Probleme einen elexis-uitest durchzuführen, GC-Heap oder memory Fehler
* Automatisches Erstellen der benötigten PostgreSQL und MariaDB-Datenbanken.
  * Jeweils von Hand gemäss Anleitung in
    * elexis-uitest/postresql/pom.xml
    * elexis-uitest/mysql/pom.xml

    
