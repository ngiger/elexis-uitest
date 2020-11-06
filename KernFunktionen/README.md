# elexis-uitest

GUI-Tests für Elexis

## Ziele

Unter https://srv.elexis.info/jenkins/view/UI-Test/ laufen CI (Continuos Integration)-Jobs, welche jeden Tag am frühen Morgen angestossen werden.

* Aufbauend auf einer leeren DB wird das Aufsetzen einer Praxis mit dem Import von Artikelstamm, Tarmed, EAL, Hilotech-TextPlugin + Vorlagen simuliert. Dann werden die wichtigsten Funktionen getestet (ohne Agenda) und eine Tarmed-XML-Rechnung erzeugt und eine AUF mit hilfe des hilotec ODF Textplugins erstellt
* Das selbe mit der französischen Version von Elexis
* Mit verschiedenen Datenbanken (PostgreSQL, H2)
* Zweig f11106 mit der neuen Persistenz basierend auf JPA

### Noch nicht verwirklichte Ideen

* Nach jeder Anpassung des Quellcode innerhalb von 15 Minuten eine Rückmeldung haben, falls einer oder mehrere wichtigsten Abläufe von Elexis nicht mehr laufen (Smoketest, z.B. Benutzer, Patient, Fall, Kons anlegen und verrechnen).
* Tests unter Windows
* Mit MySQL Datenbank
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

Da verschiedenen Elexis- und Datenbank-Setup verwendet werden können, muss man angeben, welches man verwenden will. Hier zum Testen mit elexis-3.8 und h2

    mvn -V clean verify -f elexis-3.8/pom.xml
    mvn -V clean verify -f h2/pom.xml -DuseBranch=3.8 

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
* Es darf keine LibreOffice-Instanz offen sein, falls der Test Dokumente via dem Hilotec-Plugin druckt, da sonst LibreOffice das headless ignoriert.

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

Zum Umgegehen des Ersten Mandator dialogs

    -Duser.language=de -Duser.region=CH
    -Dch.elexis.dbFlavor=h2 -Dch.elexis.dbSpec=jdbc:h2:~/elexis/first;AUTO_SERVER=TRUE -Dch.elexis.dbUser=sa -Dch.elexis.dbPw= 
    -Dch.elexis.firstMandantName=Mustermann -Dch.elexis.firstMandantPassword=elexisTest -Dch.elexis.firstMandantEmail=mmustermann@elexis.info -Dch.elexis.username=Mustermann -Dch.elexis.password=elexisTest

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

Für Linux muss z.B. openbox installiert sein, damit ein Window-Manager die Titelleiste anzeigt. Siehe z.B. run_h2.sh

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

# TODO: Cleanup

* Wenn RCPTT 2.3.1 (oder 2.4.0) herauskommt, commit vom 20.12.2018 wegen find-all rückgängig machen.
** Find-all war sauberer Lösung für locale
** find-all erlaubte filtern von SQL-Scripts, so dass nur Resultate zurückkamen
** SNAPSHOT-Version braucht jeden Tag viel zu lange, bis sie runter geladen war


