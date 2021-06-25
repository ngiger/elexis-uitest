REM Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
rem https://4sysops.com/archives/adding-and-removing-keyboard-languages-with-powershell/
$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("de-CH")
Set-WinUserLanguageList -Force $LanguageList
choco install powershell-core -y 
REM Above installs powershell 7.x which may be opened as "C:\Program Files\PowerShell\7\pwsh.exe"  
choco install openjdk8 maven git grep vim
choco install sysinternals notepadplusplus 7zip runinbash
choco install openoffice libreoffice-still
choco install Office365Business office-to-pdf

REM Weder für Eclipse RCP, RCPTT noch OOMPH gibt es einen Installer
REM choco install eclipse-java-oxygen
git clone https://github.com/elexis/elexis-uitest.git
choco install wget firefox postgresql mariadb
REM choco install mysql for mysql command line No existing my.ini. Creating default 'C:\tools\mysql\current\my.ini' with default locations for datadir.

wget https://ftp.snt.utwente.nl/pub/software/eclipse/oomph/products/eclipse-inst-win64.exe
REM Von Hand zu machen
REM eclipse-inst-win64.exe ausführen und https://raw.githubusercontent.com/elexis/elexis-3-core/master/Elexis.setup

REM http://repo.jenkins-ci.org/releases/com/sun/winsw/winsw/
rem choco install winsw geht nicht
mkdir C:\Jenkins
cd C:\Jenkins
mkdir C:\Jenkins\workdir\remoting
wget -O jenkins-slave.exe https://repo.jenkins-ci.org/releases/com/sun/winsw/winsw/2.9.0/winsw-2.9.0-net4.exe 
copy C:\Users\vagrant\scripts\jenkins-slave.exe.config
copy C:\Users\vagrant\scripts\jenkins-slave.xml
.\jenkins-slave.exe install
wget -o slave.jar https://srv.elexis.info/jenkins/jnlpJars/agent.jar
Start-Service "JenkinsSlave" -PassThru
