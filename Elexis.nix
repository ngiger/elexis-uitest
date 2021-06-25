# Helper to add Elexis to a NixOS system, must be installed using the following steps
# mvn -V clean -f verify elexis-master/pom.xml
# nix-build Elexis.nix; nix-env -i result/
with (import <nixpkgs> {});
let pname = "Elexis";
  version = "3.9";
  exec = "elexis";
  icon = "$out/app/icon.xpm";
in 
stdenv.mkDerivation {

  demoDB = pkgs.fetchurl {
    url = "http://download.elexis.info/demoDB/demoDB_elexis_3.8.0.zip";
    sha512 = "sha512-nNSmQPG8WRJ7mB1z0EYrunOgq0nQLiSQYzsgfPdgAcxKV1neHYCpfueDwjMHKvOnJnuJOBmtqRMcoQO43ZgHcg==";
  }; 
  name = "${pname}-${version}";
  exec = "${exec}";
  icon = "${icon}";
  description = "An eclipse RCP application for all aspect of a medical Swiss german practice";
  longDescription = ''
    Elexis ist eine umfassende open source Software für die Arztpraxis, 
    welche 2008 von Dr. Gerry Weirich entwickelt wurde und seither von der
    Medelexis AG, den Entwicklern und Anwendern laufend verbessert wurde.  
  '';
  homepage    = "https://elexis.info/";
  changelog   = "https://github.com/elexis/elexis-3-core/blob/master/Changelog";
#  license     = licenses.epl20;
#    maintainers = with maintainers; [ ngiger ];
#    platforms   = platforms.unix;
  inherit gcc coreutils perl glibc busybox makeWrapper stdenv patchelf  ;
  nativeBuildInputs = [ unzip  ];
  src = elexis-master/target/products/ElexisAllOpenSourceApp-linux.gtk.x86_64.zip;

  desktopItem = makeDesktopItem {
    name = "${pname}-${version}";
    exec = "${exec}";
    icon = "${icon}";
    comment = "An eclipse RCP application for all aspect of a medical Swiss german practice";
    desktopName = "Elexis Swiss German desktop";
    genericName = "ElexisOS";
    categories = "Office;";
  };

  desktopItemDemoDB = makeDesktopItem {
    name = "${pname}-${version}-demoDB";
    exec = "${exec}-demoDB";
    icon = "${icon}";
    comment = "Test Elexis with demoDB (using a H2 database ~/elexis/demoDB)";
    desktopName = "Elexis with a demoDB";
    genericName = "ElexisOS";
    categories = "Office;";
  };

  buildInputs = [
    cairo
    fontconfig
    freetype
    glib
    gsettings-desktop-schemas
    gtk3
    makeWrapper
    openjdk8
    unzip
    webkit
    openjfx11 # openjfx
    webkitgtk
    xorg.libX11
    xorg.libXrender
    xorg.libXtst
    zlib
  ] ;
  unpackPhase = ''
    echo Niklaus: unpackPhase von Niklaus
      mkdir -pv "$out/app" 
      unzip -qd "$out/app" $src
    echo Unzipped into $out from $src
  '';
  
  phases = [ "unpackPhase" "buildPhase" ] ;
  ldPath = "${lib.makeLibraryPath ([ glib gtk3 xorg.libXtst openjfx11 webkit webkitgtk ])}";
  setElexisEnv =  writeScriptBin "setElexisEnv" ''
      #!${pkgs.stdenv.shell}
#       # Generate a small helper script for running RCPTT test via mvn rpctt plugin
      export LD_LIBRARY_PATH='$ldPath'
      export XDG_DATA_DIRS='${gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-40.0'
      export GIO_EXTRA_MODULES='${glib_networking}/lib/gio/modules'
      export JAVA_HOME='${pkgs.openjdk8}'
  '';
  buildPhase = ''
    # Unpack tarball.
    mkdir -pv $out/bin
    cp -v $setElexisEnv/bin/setElexisEnv  $out/bin
    # Patch Elexis3 binary AND the embedded java from the JRE
    interpreter=$(echo ${stdenv.glibc.out}/lib/ld-linux*.so.2)
    patchelf \
    --set-interpreter $interpreter $out/app/Elexis3 \
    --set-rpath $ldPath \
    $out/app/Elexis3
    patchelf --set-interpreter $interpreter $out/app/plugins/*/jre/bin/java

    makeWrapper $out/app/Elexis3 $out/bin/"${exec}-h2_rcptt_de" \
      --prefix PATH : ${openjdk8}/bin \
      --prefix LD_LIBRARY_PATH : $ldPath \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --add-flags "-nl de_CH -os linux -ws gtk -arch x86_64 -consoleLog -vmargs \\
          -Duser.language=de -Duser.region=CH -Dfile.encoding=utf-8 \\
          -Dch.elexis.dbFlavor=h2 -Dch.elexis.dbSpec='jdbc:h2:~/elexis/h2_elexis_rcptt_de/db;AUTO_SERVER=TRUE' \\
          -Dch.elexis.dbUser=sa -Dch.elexis.dbPw=  \\
          -Dch.elexis.firstMandantName=Mustermann -Dch.elexis.firstMandantPassword=elexisTest -Dch.elexis.firstMandantEmail=mmustermann@elexis.info \\
          -Dch.elexis.username=Mustermann -Dch.elexis.password=elexisTest"

# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/p2p/vuze/default.nix wegen swt lib 
  makeWrapper $out/app/Elexis3 $out/bin/${exec} \
      --prefix PATH : ${openjdk8}/bin \
      --prefix LD_LIBRARY_PATH : $ldPath \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --add-flags "-nl de_CH -os linux -ws gtk -arch x86_64 -consoleLog"
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/p2p/vuze/default.nix wegen swt lib 
  makeWrapper $out/app/Elexis3 $out/bin/"${exec}-demoDB" \
      --run "[[ ! -d ~/elexis/demoDB ]] && ${unzip}/bin/unzip $demoDB -d ~/elexis" \
      --prefix PATH : ${openjdk8}/bin \
      --prefix LD_LIBRARY_PATH : $ldPath \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --add-flags "-nl de_CH -os linux -ws gtk -arch x86_64 -consoleLog \
      -configuration ~/elexis/.demo_config \
      -vmargs \
-Duser.language=de -Duser.region=CH -Dfile.encoding=utf-8 \
-Dch.elexis.dbFlavor=h2 -Dch.elexis.dbSpec='jdbc:h2:~/elexis/demoDB/db;AUTO_SERVER=TRUE' \
-Dch.elexis.dbUser=sa -Dch.elexis.dbPw= "

    ${gnugrep}/bin/egrep 'bash|export' $out/bin/${exec} > $out/bin/get_exports
    chmod +x $out/bin/get_exports
    # Create desktop items
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications
    cp $desktopItemDemoDB/share/applications/* $out/share/applications
  '';
  system = builtins.currentSystem;
}
