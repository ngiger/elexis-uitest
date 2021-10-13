# Virtual Machines zum Testen von Elexis

Hier findet man alle Dateien, um mit Hilfe von [vagrant](https://www.vagrantup.com/) virtuelle Maschinen einzurichten.

Ich verwende dazu VirtualBox, da ich damit am wenigsten Probleme mit der Tastatur, Fenstern, etc habe.

Folgende Alternativen habe ich verworfen:
* virsh (aka: kvv/qem) mit virt-manager. Aufsetzen ohne grosse Problem. Probleme mit Tastatur
* Gnome-Boxes, verwenden zwar auch virsh, tauchen jedoch im virt-manager nicht auf

## Konfiguration der Maschinen

Damit die Elexis-Uitest flüssig laufen, sind folgende Parameter gewählt:

* 3 CPUS
* 8 GB RAM # Kann auch etwas kleiner sein, siehe memory Parameter in den Vagrantfile
* 100 GB Diskspace für Windows
* 100 GB Diskspace für Debian



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

## Headless gebrauch

VBoxManage list vms
VBoxManage modifyvm ec3af3a9-d102-4791-b20c-d91066bd35bf --vrde on
VBoxManage modifyvm 52b7bae4-0b92-44ee-bd88-43b1d0e1796f --vrde on
 VBoxManage list vms
"elexis-buster" {ec3af3a9-d102-4791-b20c-d91066bd35bf}
"elexis-windows" {52b7bae4-0b92-44ee-bd88-43b1d0e1796f}

We could use in the vagrant file vagrant_name = "elexis-windows-" + Etc.getlogin


remmina&
Dort RDP auswählen und 0.0.0.0:33389 eingeben

--autostart-enabled on|off: Enables and disables VM autostart at host system boot-up, using the specified user name. 
--autostart-delay <seconds>: Specifies a delay, in seconds, following host system boot-up, before the VM autostarts. 


```
cd elexis-buster
vagrant halt
VBoxManage modifyvm "elexis-buster" --vrde on
VBoxManage modifyvm "elexis-buster" --autostart-enabled on
VBoxManage showvminfo elexis-buster | grep Autostart
VBoxHeadless --startvm elexis-buster --vrde on
# or (if headless packet not installed)
VBoxManage startvm elexis-windows --type headless
```

## Benutzung als slave für Jenkins

https://blog.doenselmann.com/jenkins-slave-agent-als-windows-dienst-mit-openjdk/


## TODO

* Konfiguration, dass Java korrekt konfiguriert ist, um ohne Probleme einen elexis-uitest durchzuführen, GC-Heap oder memory Fehler
* Automatisches Erstellen der benötigten PostgreSQL und MariaDB-Datenbanken.
  * Jeweils von Hand gemäss Anleitung in
    * elexis-uitest/postresql/pom.xml
    * elexis-uitest/mysql/pom.xml

    
