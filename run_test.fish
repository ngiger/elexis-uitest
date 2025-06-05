#!/usr/bin/env fish
# (c) 2025 Copyright by Niklaus Giger, niklaus.giger@member.fsf.org
argparse b/branch= l/language= d/dbtype= s/suite= z/zipfile=  h/help -- $argv
or return
if set -q _flag_help
    echo "Usage: build_branch b/branch=3.12 l/language=de d/dbtype=h2 s/suite=SmokeTestSuite z/zipfile=aZipFile  h/help"
    echo "Will run the RCPTT suite for given branch/database type/language using the AUT"
    echo "  Specify de, fr or it for the language. Default is de"
    echo "  Specify postgresql, mysql or h2 for the dbtype. Default is h2"
    echo "  by default the SmokeTestSuite is run"
    echo "  by default we test the 3.12 branch"
    echo "  AUT (Application Under Test) is by default elexis-3.12/target/products/ElexisAllOpenSourceApp-linux.gtk.x86_64.zip"
    return 0
end
# Default for branch
set -l branch 3.12
set -ql _flag_branch[1]
and set branch $_flag_branch[-1]

# Default for language
set -l language de
set -ql _flag_language[1]
and set language $_flag_language[-1]

# Default for dbtype
set -l dbtype h2
set -ql _flag_dbtype[1]
and set dbtype $_flag_dbtype[-1]

# Default for suite
set -l suite SmokeTestSuite
set -ql _flag_suite[1]
and set suite $_flag_suite[-1]

# Default aut suite
set -l aut elexis-3.12/target/products/ElexisAllOpenSourceApp-linux.gtk.x86_64.zip
set -ql _flag_aut[1]
and set aut $_flag_aut[-1]

set autDir os-$branch
rm -rf $autDir
unzip -o -d $autDir $aut 1>/dev/null

echo "Running $suite (branch $branch) for db $dbtype and language $language"
set pom_xml  elexis-$branch/pom.xml
if test -f $pom_xml
  echo Found $pom_xml for branch $branch
else
  echo Unable to find $pom_xml for branch $branch
  return 1
end
set zip_file elexis-$branch/target/products/*zip
echo zip_file is $zip_file
set cmd mvn -V --batch-mode clean install --settings=$dbtype/settings.xml -f $dbtype/pom.xml -DuseBranch=$branch -Dlanguage=$language -DautExplicit=$autDir/Elexis3
$cmd 2>&1 | tee mvn-(date '+%Y-%m-%d-%H-%M').log
set result $status
echo "Maven returned $result mit $status branch $_flag_branch"
ls -lh Kernfunktionen/target/results/Kernfunktionen.html
return $result
