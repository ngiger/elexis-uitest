# elexis-uitest

## Probleme mit 3.12

Neuerungen sind beschrieben unter https://support.medelexis.ch/docs/version-3-12/

    Rollen und Rechte: Überarbeitung
    Die Rollen und Rechte wurden laut den Vorgaben des BAG überarbeitet. 

Aber das Format der zu importierenden Datei ist nirgends dokumentiert, noch ein Beispiel vorhanden

SetzeSpracheBeiImportern ist nicht mehr möglich
Importer Import von externen Daten läuft nicht mehr Universal_patienten.xls und Universal_krankenkasse.xls nicht mehr möglich

Wegen problemen von NixOS mit justj
    * If elexis-3.12/ElexisAll.product entfernen von `<feature id="org.eclipse.justj.openjdk.hotspot.jre.full" installMode="root"/>`?
    * In elexis-3.12/pom.xml `<executionEnvironment>JavaSE-17</executionEnvironment>` nach none?
    * Oder elexis-3.12/patch_elexis3.rb als step einbauen?

java.lang.Exception: Insufficient rights [requires crudi] on objects [ch.elexis.base.ch.labortarif.ILaborLeistung]
        at ch.elexis.core.ui.util.ImporterPage$ImporterJob.run(ImporterPage.java:143)
        at org.eclipse.core.internal.jobs.Worker.run(Worker.java:63)
Deshalb laufen folgende Importer nicht:
  * Import Analysenlist
  * Import Blöcke
  * Import Komplementärmedizin
  * Import Tarmed
Weiter wurde ConfigureDocx_TextVerarbeitung geändert
Beim Erstellen der Patienten kann die AHV mangels Berechtigung nicht erstellt werden, aber kein PopUp-Meldung erscheint!!
  (Bei Patienten.test auf Zeile 131, nur AHV eingeben, wenn vorhanden)
quickget debian 12.11.0 gnome

ObjectEvaluatableACE(type, Right.IMPORT).and(Right.CREATE)
										.and(Right.UPDATE).and(Right.DELETE).and(Right.READ)))
Welche Workaround gibt es für
SWT OS.java Error: Failed to load swt-pi3, loading swt-pi4 as fallback.

GUI-Tests für Elexis
* ImportAnalysenListe 1006
* ImportBlocks
* ImportTarmed select-tarmed-leistung 01.01.01 
* ImportMigel Absaug
* ImportEigendiagnose
* ImportEigenleistung Window Eigenleistung could not be found
* BasicAbrechnungssystem Privatrechnung not found
* ImportArtikelstammFull Failed to set selection: [[Losartan.*Stk.*]].
* CreateFemalePatient Cannot execute command on the required control Elexis 3.12.0.20250604-0834 -  Mustermann Max / Weirich Gerry  / Müller Manon (w), 13.05.1985 (40) - [1] because there is still the active modal dialog "Identifikationselemente".
  * Dito KonsDirektVerrechnen
  * Dito TarmedFallberechen
  * ..
* TimeTool
* CreateAndPrintPrescription

### Failing tests with 3.12


## Ziele

Unter https://srv.elexis.info/jenkins/view/UI-Test/ laufen CI (Continuos Integration)-Jobs, welche jeden Tag am frühen Morgen angestossen werden.

* Aufbauend auf einer leeren DB wird das Aufsetzen einer Praxis mit dem Import von Artikelstamm, Tarmed, EAL, Hilotech-TextPlugin + Vorlagen simuliert. Dann werden die wichtigsten Funktionen getestet (ohne Agenda) und eine Tarmed-XML-Rechnung erzeugt und eine AUF mit hilfe des hilotec ODF Textplugins erstellt
* Das selbe mit der französischen Version von Elexis
* Mit verschiedenen Datenbanken (PostgreSQL, H2)
* Zweig f11106 mit der neuen Persistenz basierend auf JPA

### Noch nicht verwirklichte Ideen

* Nach jeder Anpassung des Quellcode innerhalb von 15 Minuten eine Rückmeldung haben, falls einer oder mehrere wichtigsten Abläufe von Elexis nicht mehr laufen (Smoketest, z.B. Benutzer, Patient, Fall, Kons anlegen und verrechnen).
* Tests unter Windows
* Mit Datenbank-Zugriff via Elexis-Server
* Ausführliche Tests regelmässig (täglich/wöchentlich) mit verschiedenen Betriebssystem durchführen.
* Updates verschiedener Kombination von Features von der Vorgängerversion auf die aktuelle automatisch testen können.
* Erfahrene Elexis-Anwender sollen mit maximal 1/2 Tag Aufwand ermächtigt werden können, Testfälle in ihrer eigenen Umgebung (DB) so aufzuzeichnen, dass diese von den Entwicklern übernommen und paramatrisiert werden können.
* Hilotec-Text-Plugin mit LibreOffice und mit allen Hilotec-Textvorlagen + 1 Test-Vorlage (z.B mit allen Platzhalter) PDFs erzeugen und Inhalt testen.

## Flexibilität

Niklaus machte folgende Schritte, damit das Testen auf lange Sicht mit der DemoDB und RunFromScratch einfach bleibt.

* Vorbedingen testen [Preconditions](KernFunktionen/Hilfen/Kontexte/Preconditions.ctx)
* Funktionen für häufig gebrauchtes, wie z.B. get-user-dir, welches den Wert ch.elexis.core.data.activator.CoreHub.getWritableUserDir() zurückgibt.  [ecl_helpers](KernFunktionen/Hilfen/Kontexte/ecl_helpers.ctx)

## Testfälle auf Kommandozeile ausführen lassen

Dazu wird Maven verwendet [Download](https://maven.apache.org/download.cgi). Die Versionen 3.5.2 und 3.6 liefen ohne Probleme (3.3.9 führte zu Problemen).

Da verschiedenen Elexis- und Datenbank-Setup verwendet werden sollen, können die verschiedenen Parameter (aka Maven properties) in einem settings.xml angegeben werden. Dies wurde für die folgenden DBs gemacht

* h2 (Vorgabewert)
* mysql
* postresql

Dazu gibt es in jedem entsprechenen Unterverzeichnis, ein Maven pom.xml und settings.xml. Um den Ablauf zu testen,
verwende ich eine spezielle Test-Suite QuickTestSuite (Vorgabewert ist SmokeTestSuite), welche viel weniger Zeit braucht. Via Kommandozeile gebe
ich an, ob ich die den Zweig master (Vorgabewert) oder 3.8 testen will. Andere Zweige werden im Moment nicht unterstützt.

In den Verzeichnissen elexis-master und elexis-3.8 wird für die aktuelle target runtime ein RCP-Produkt erstellt,
welches alle OpenSource-Features aus den repositories elexis-3-core und elexis-3-base.

So sieht am Schluss ein Aufruf zum erstellen eine elexis-3.8 RCP-Applikation für eine mysql-Datenbank testet

    mvn -V clean verify -f mysql/pom.xml --settings mysql/settings.xml -DuseBranch=3.8 -Dsuite2run=QuickTestSuite  

Tipp: Falls man die Farben nicht gerne hat im Output, kann dies mit folgende Maven-Option unterbinden `-Dstyle.color=none`

## Neue Testfälle erstellen

### Voraussetzunge

* Englischkenntnisse (RCPTT ist nur auf Englisch dokumentiert)
* Erfahrung mit Elexis
* Vorhandene Elexis-Installation (>= 3.7.0) und Datenbank z.B [installierte DemoDB](https://wiki.elexis.info/Installation_Elexis_3.0_demoDB)
* Installiertes RCPTT-Programm [Download](https://www.eclipse.org/rcptt/download/)
* In RCPTT muss in der View "Applications" mit einem Doppelclick ein Elexis (nachfolgend ElexisDemoDB) genannt definiert werden.
** Da Elexis im master Zweig auf eclipse 2018-09 aufsetzt, müssen die Snapshot-Versionen von rcptt verwendet werden bis RCPTTT 2.3.1 herauskommt, z.B. viaa
  http://download.eclipse.org/rcptt/nightly/2.4.0/201901240014/ide/rcptt.ide-2.4.0-N201901240014-linux.gtk.x86_64.zip
* maven > 3.3.9 (z.B. 3.5.2 oder 3.6.0) zum Starten der Tests auf der Komandozeile z.B via `-V clean verify  -f RunFromScratch/pom.xml -Dsuite2run=SmokeTestSuite`
* OpenOffice muss installiert sein (siehe EnsureOpenOfficeIsInstalled in  KernFunktionen/Tests/Textverarbeitung/text_plugins_common.ctx). see https://www.openoffice.org/download/index.html
** May using direct URL https://jztkft.dl.sourceforge.net/project/openofficeorg.mirror/4.1.9/binaries/de/Apache_OpenOffice_4.1.9_Linux_x86-64_install-deb_de.tar.gz
** Vorgabepfad ist /opt/openoffice4/program/swriter. Dieser sollte nicht geändert werden
** Man muss zuerst mal von Hand den Benutzernamen/Kürzel eingeben, da sonst swriter nicht startet (Wird in Datei ~/.openoffice/4/user/registrymodifications.xcu gespeichert)
* LibreOffice muss installiert sein (siehe EnsureLibreOffficIsInstalled in  KernFunktionen/Tests/Textverarbeitung/text_plugins_common.ctx)
* Es darf keine LibreOffice-Instanz offen sein, falls der Test Dokumente via dem Hilotec-Plugin druckt, da sonst LibreOffice das headless ignoriert.
* import utility muss unter Linux installiert sein (Debian buster Paket imagemagick)

### AUT definieren

In der View "Applications" via Kontext-Menu (Rechtsklick) den Punkt "New.." anwählen. Dort

* Unter "Location" den Pfad des installierten Elexis angeben, als z.B. "C:\Tests\Elexis-3.7". Sobald der Pfad ausgewählt wurde, lädt sich RCPTT die Liste der installierten Plugins ein.
* Falls keine entsprechende 32-bit oder 64-bit JVM definiert ist, muss man eine solche hinzufügen (Pfad auf Installation (ohne Unterverzeichnis bin))
* Unter "Name" einen Namen eingeben. Hier nehmen wir ElexisDemoDB.
* Auf Finish drücken
* Via Rechtsklick auf ElexisDemoDB den Eintrag "Configure.." anwählen
* Auf "Advanced" drücken.
* Unter "Arguments" die [Startoptionen](https://wiki.elexis.info/Startoptionen) von Elexis anpassen. Hier 3 Beispiele

Für DemoDB unter Pfad\zu\Benutzer\elexis\demoDB hinzufügen

    -Dch.elexis.username=test -Dch.elexis.password=test

Für H2 demoDB unter C:\Tests\db (Unter Pfad\zu\Benutzer\elexis darf allerdings kein demoDB-Verzeichnis vorhanden sein!) hinzufügen

    -Dch.elexis.username=test -Dch.elexis.password=test
    -Dch.elexis.dbUser=sa -Dch.elexis.dbPw=""
    -Dch.elexis.dbFlavor=h2  -Dch.elexis.dbSpec="jdbc:h2:C:\Tests\db/demoDB/db;AUTO_SERVER=TRUE"
    
Für RunFromScratch (leere DB mit 007 als Arzt) hinzufügen

    -Dch.elexis.dbUser=sa -Dch.elexis.dbPw="" -Dch.elexis.dbFlavor=h2
    -Dch.elexis.dbSpec="jdbc:h2:C:\Tests\runFromScratch/db;AUTO_SERVER=TRUE"
    -Delexis-run-mode=RunFromScratch
    -Dch.elexis.username=007 -Dch.elexis.password=topsecret

* Sich überlegen, ob man eine separate config-xml-Datei verwenden will. Wenn ja dann `--use-config=anstell_von_local` hinzufügen
* Mit Doppelclick ElexisDemoDB starten

Zum Umgehen des Ersten Mandator dialogs

    -Duser.language=de -Duser.region=CH
    -Dch.elexis.dbFlavor=h2 -Dch.elexis.dbSpec=jdbc:h2:~/elexis/first;AUTO_SERVER=TRUE -Dch.elexis.dbUser=sa -Dch.elexis.dbPw= 
    -Dch.elexis.firstMandantName=Mustermann -Dch.elexis.firstMandantPassword=elexisTest -Dch.elexis.firstMandantEmail=mmustermann@elexis.info -Dch.elexis.username=Mustermann -Dch.elexis.password=elexisTest
    
## AUT starten

Nach dem Definieren der AUT kann man sie durch Doppelclick starten. Falls der Erste Mandator dialog umgangen wird, muss man von Hand nochmals neu starten, nachdem die AUT sich geschlossen hat.

Falls sich eine AUT nicht starten lösst und nur die Log-Datei angeschaut werden kann, muss man in der AUT launch-Datei die Zeile, welche ATTR_AUT_LAUNCH_ID löschen und sie nochmals starten

## Test aufnehmen

* Auf das Icon mit dem roten Punkt "Record a Snippet" drücken
* Im neu aufgehenden Fenster "Control Panel" werden die Aktionen, welche in Elexis ausgeführt werden, protokolliert. Z.B.

    get-preferences-menu | click
    get-window Benutzervorgaben | get-button Abbrechen | click

Fortgeschrittene Benutzer können Assertions benutzen, um zu beschreiben, wie das Fenster auszusehen hat, z.B. ob eine Auswahl möglich ist oder nicht.

Dazu im Fenster "Control Panel" kann man mit Hilfe eines Toolbar-Button "Switch to Assertion Mode" in den Assertions-Modus wechseln, um Inhalte von einzelnen Elementen zu überprüfen.

Um zu Testen, ob die Liste der Patienten anwählbar ist, wird folgender Text hinzugefügt

    get-view Patienten | get-table | get-property enablement | equals true | verify-true

## Test nachbearbeiten

Dieser Schritt wird von Entwickler und erfahrenen RCPTT-Benutzern gemacht, um die Flexibilität, Wiederverwendbarkeit, Wartbarkeit und Mächtigkeit der gesamten Testfälle zu erhöhen.

Für die Wartbarkeit ist es sinnvoll, dass jedes Elexis-Element (Dialog, View, etc) nur an einer (oder wenigen) Stellen im Code vorkommt und über  [Parameter](https://www.eclipse.org/rcptt/documentation/userguide/procedures/) gesteuert vielseitig aufgerufen werden kann. Dazu werden [ECL-Scripts](https://www.eclipse.org/rcptt/documentation/userguide/contexts/ecl/), welche von RCPTT als Kontext behandelt werden.

Innerhalb solcher Prozeduren/ECL-Scripts macht es Sinn, viele Schritte mit Hilfe von [Assertions](https://www.eclipse.org/rcptt/documentation/userguide/assertions/) zu überprüfen

### Verifikationen

Die Verifikationen von Marco habe ich gelöscht, da ich sonst Probleme habe, dies mit der DemoDB und RunFromScratch zum Laufen lassen. Muss mir mal noch überlegen, wo dies Sinn macht.

## Continuos Integration

Nachdem zuerst Tests mit der DemoDB liefen, habe ich im Januar 2019 Unterverzeichnisse für demoDB und RunFromScratch angelegt.

Hier bin ich mir noch nicht klar, wie diese strukturiert sein sollen und ggf via properties gesteurt (z.B: für Matrix-Projekte von Jenkins).

Für Linux-Builds muss die Bibliothek librxtx-java installiert.

Für Linux muss z.B. openbox + menu (wegen /var/lib/openbox/debian-menu.xml) installiert sein, damit ein Window-Manager die Titelleiste anzeigt. Siehe z.B. run_h2_de.sh. Use openbox-session if you do not want to see the window titles in the generated screenshots.

Für das Testen des OpenOffice Text plugins braucht es einen PDF-Printer, z.B. das Debian Paket printer-driver-cups-pdf

# Gemachte Anpassungen an Elexis

* Patch von Marco, nicht sicher ob das notwendig/gut ist. [14722] ElEvDispatcher move from Eclipse Job to SchdldExecutorService Siehe https://github.com/elexis/elexis-3-core/commit/d1020e0cff157bf074d4a7e4a62869249e9fd93a

Auch wenn uns Xored abrät, diesen Patch zu benutzen, lasse ich ihn im Moment trotzdem aktiviert, da nur so ein flüssiges Arbeiten mit RCPTT und Elexis möglich ist. Beim Arbeiten mit dem Artikelstamm habe ich jedoch festgestellt, dass es hier zu Problemen kommen kann, da hier häufig Aktionen (Auswahl eines Medi) relativ lange dauern und hier wahrscheinlich die von Xored befürchteten Race-Conditions auftreten.


# Eigenheit der ECL (Eclipse Command Language)

Erinnert ein wenig an TCL. Ist gewöhungsbedürftig.

So sind z.B. Bedingung und Prozduren wie folgt zu schreiben
    proc "MeineProzedur" [ var param ] {
        if [$param div 10 | equals 0] {
            bool true // Return wert ist jeweils die zuletzt ausgeführte Funktion. Es gibt kein Return Statement
        }
    }

Procedures can define ‘input’ arguments and default values for arguments:
    // Declaring:
    proc set-text-after-label [val parent -input] [val label] [val text ""] {
        $parent | get-editbox -after [get-label $label] | set-text $text
    }
    // Using -- text arg is not set, so default value will be used
    get-window "New Project" | set-text-after-label "Project name:"

## Auf französisch testen

Damit man mit -nl fr_CH aufstarten kann, muss vorgäng in der DB das Statement `update config set wert = 'fr_CH' where param = 'locale';` ausgeführt werden. Damit Tests via maven auf französisch ausgeführt werden, muss als maven wie folgt  aufgerufen werden `mvn clean verify -Dlocale=fr_CH`

### Erkannte Probleme mit der französischen Version

* Wenn man auf Französisch einen Fall erstelllt, wird der z.B: mit LAMal: maladie en général angezeigt auch wenn man nachher auf Deutsch startet.
* Diverse Übersetzungen sind schlecht. Siehe translations.properties
* Das Erstellen eines neuen Mandanten ist nicht übersetzt


## Einen anderen Branch testen (z.B. NoPo)

`mvn clean verify -Dusebranch=fr_CH`

## Testen mit Xvfb (headless)

Die Screenshots sehen hässlich aus, wenn nicht eine volle Gnome/KDE-Umgebung installiert ist.

Niklaus fehlt die Zeit um genau herauszufinden, welche Pakte (wahrschein nur Fonts) fehlen. (fonts-freefont-otf fonts-linuxlibertine fonts-lmodern fonts-texgyre xfonts-scalable xfonts-unifont libfonts-java xfonts-100dpi xfonts-75dpi ttf-unifont) scheinen zu reichen.

Lokal lässt Niklaus dann die Builds wie folgt laufen: `xvfb-run -screen 0 1400x1024x24 -a mvn clean verify 2>&1 | tee maven.log`. The dimension of the screen are important or the images are very ugly (at least when running via Jenkins).

## Neuaufsetzen einer Praxis-DB

Dazu muss die Datei praxis.properties angpasst werden. Ebenso muss eine leere Datenbank erstellt werden, z.B. via `sudo -u postgres psql` folgende eingeben

    drop database if exists mustermann;
    create database mustermann encoding 'utf8' template template0;
    create user mustermann with UNENCRYPTED password 'elexisTest';
    GRANT ALL PRIVILEGES ON DATABASE mustermann TO mustermann ;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO mustermann;
    \q


# Ideen für das weitere Vorgehen

Es braucht eventuell eigene Anpassungen, um die DatePicker testen zu können. s.a https://github.com/xored/rcptt.extensions.ecl

Wöchentlichen CI-Jobs erstellen, der einzeln base + 1 feature lädt, damit fehlende Abhängigkeiten gefunden werden können (z:B. CST). Dazu muss man den Test fehlschlagen lassen, wenn Fehlermeldung "Die Ansicht konnte nicht erstellt werden" auftaucht.


Unter https://github.com/xored/q7.examples.multirun/tree/master/tests/q7tests findet man eine Lösung, wie man Tests auf verschiedenen Platformen aufrufen kann.
https://github.com/xored/q7.examples.multirun/tree/master/tests/q7tests

https://github.com/xored/q7.examples.jacoco

https://www.eclipse.org/rcptt/blog/2015/06/17/code-coverage.html

https://www.eclipse.org/rcptt/blog/2014/11/21/screenshots-with-rcptt.html

https://www.eclipse.org/rcptt/blog/2014/12/10/test-about-dialog.html

# Jenkins Master aufsetzen

* https://srv.elexis.info/jenkins/configureSecurity/ In "TCP port for inbound agent" use a static port
* https://wiki.jenkins.io/display/JENKINS/Step+by+step+guide+to+set+up+master+and+agent+machines+on+Windows

## Jenkins MacOSX Slave aufsetzen

* Benutzer erzeugen
* MacOSX node auf jenkins Instanz erzeugen
* Starten via agent testen (evt. JDK/OpenWebStart dazu intallieren)
* git installieren
* OpenOffice installieren und einmal aufstarten (als Benutzer Jenkins), damit Vorname/Name/Kürzel gesetzt wird
* LibreOffice installieren und einmal aufstarten (als Benutzer Jenkins), damit Vorname/Name/Kürzel gesetzt wird
* Einen Daemon (Hintergrund-Program) dazu einrichten.
** URL und secret in setup/data/plist.xml anpassen

    sudo cp setup/data/plist.xml /Library/LaunchDaemons/com.jenkins.ci.plist
    sudo chmod 644 /Library/LaunchDaemons/com.jenkins.ci.plist
	sudo launchctl load /Library/LaunchDaemons/com.jenkins.ci.plist
	sudo launchctl list com.jenkins.ci


## Jenkins Windows Slave aufsetzen

* Benutzer erzeugen
* MacOSX node auf jenkins Instanz erzeugen
* Starten via agent testen (evt. JDK/OpenWebStart dazu intallieren)
* OpenOffice installieren und einmal aufstarten (als Benutzer Jenkins), damit Vorname/Name/Kürzel gesetzt wird
* LibreOffice installieren und einmal aufstarten (als Benutzer Jenkins), damit Vorname/Name/Kürzel gesetzt wird
* Einen Daemon (Hintergrund-Program) dazu einrichten.

* git bash installieren
** git config core.fileMode false # setzen, damit bei *.sh-Dateien nicht immer als git status new mode 0644 gemeldet wird
* mysql installieren (falls mysql DB verwendet wird)
* Build einmal von Hand auf Slave ausführen (wegen Zugriffsberechtigungen, z.B. für Java JDK)
* startup script für windows slave ?? 
* als Windows Service installieren ??

Es gibt unter vagrant/elexis-windows ein Vagrant setup, das die meisten dieser Aufgaben übernehmen kann.

# Testen unter Windows10

Folgende Schritte wurden unter Windows10 durchgeführt, um alle benötigten Programme
zu installieren (in einer PowerShell mit administrativen Rechten)

## Chocolatey install script für irgendein Programm

    # gemäss https://chocolatey.org/install
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Damit diverse Hilfsprogramme benutzt werden können, muss jetzt eine neue PowerShell oder Git Bash Kommandozeile
geöffnet werden und die entsprechenden Zeilen aus dem [Vagrantfile](vagrant/elexis-windows/Vagrantfile) ausgeführt werden

Danach muss man von Hand

* ggf. Tastaturlayout und deutsche language pack installieren
* OpenOffice mal aufstarten, und Benutzername/Kürzel setzen
* unzip rcptt.ide-2.5.2-nightly-win32.win32.x86_64.zip (für RCPTT)
* eclipse-inst-jre-win64.exe ausführen und gemäss https://github.com/elexis/elexis-3-core/blob/master/ch.elexis.sdk/ installieren
* Create users and databases for mysql and/or postgresql as specified in [mysql/pom.xml](mysql/pom.xml) and [postgresql/pom.xml](postgresql/pom.xml)
