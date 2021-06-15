{ stdenv, jdk11_headless, maven }:
with stdenv;
mkDerivation {
    name = "maven-dependencies";
    buildInputs = [ jdk11_headless maven ];
    src = ./.;
    buildPhase = ''
      while mvn package -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
        echo "timeout, restart maven to continue downloading"
      done
    '';
    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
        find $out/.m2 -type f -regex '.+\\(\\.lastUpdated\\|resolver-status\\.properties\\|_remote\\.repositories\\)' -delete
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "026wmcpbdvkm7xizxgg0c12z4sl88n2h7bdwvvk6r7y5b6q18nsf";
  };
