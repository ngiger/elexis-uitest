REM Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install openjdk8 maven git
choco install sysinternals notepadplusplus 7zip runinbash
choco install openoffice libreoffice-still
choco install Office365Business office-to-pdf

REM Weder für Eclipse RCP, RCPTT noch OOMPH gibt es einen Installer
REM choco install eclipse-java-oxygen
git clone https://github.com/elexis/elexis-uitest.git
choco install wget firefox postgresql mariadb
wget https://ftp.snt.utwente.nl/pub/software/eclipse/oomph/products/eclipse-inst-win64.exe
REM Von Hand zu machen
REM eclipse-inst-win64.exe ausführen und https://raw.githubusercontent.com/elexis/elexis-3-core/master/Elexis.setup
