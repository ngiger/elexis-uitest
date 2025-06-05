#!/usr/bin/env fish
# (c) 2025 Copyright by Niklaus Giger, niklaus.giger@member.fsf.org
argparse "b/branch=" h/help -- $argv
or return
if set -q _flag_help
    echo "Usage: build_branch [-h | --help] [-b | --branch=NAME]" >&2
    echo "  Will build the Elexis Opensource application for the given branch (default 3.12)"
    return 0
end
# Default for branch
set -l branch 3.12
set -ql _flag_branch[1]
and set branch $_flag_branch[-1]

set pom_xml  elexis-$branch/pom.xml
if test -f $pom_xml
  echo Found $pom_xml for branch $branch
else
  echo Unable to find $pom_xml for branch $branch.
  return 1
end
mvn -V --batch-mode -f $pom_xml clean install
set result $status
echo "Maven returned $result mit $status branch $branch"
ls -lh elexis-$branch/target/products/*zip
return $result
