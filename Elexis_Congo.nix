# Helper to add Elexis to a NixOS system, must be installed using the following steps
# mvn -V clean -f verify elexis-master/pom.xml
# nix-build Elexis.nix; nix-env -i result/
with (import <nixpkgs> {});
let pname = "Elexis";
  version = "3.10";
  exec = "Elexis3-Congo";
  icon = "icon";
in 
stdenv.mkDerivation {

  demoDB = pkgs.fetchurl {
    url = "https://download.elexis.info/elexis/demoDB/demoDB_elexis_3.9.0.zip";
    sha512 = "sha512-GAKE5pUreTl1Uhx8ilrXC/q3vLPJNWeSc+Bha+L3VU2OiGmuHPmJqr8C2jv8CfEaN34+KI8Hq86wBANipDvEew==";
  }; 
  name = "${pname}-${version}";
  icon = "${icon}";
  longDescription = ''
         Elexis pour le congo - www.elexis.info
         Une version française d'Elexis pour le congo.
         Un projet initié par Victor Mboka et Niklaus Giger.
         Uniquement possible grace au travail immense de
         Gerry Weirich, Marco Descher, Thomas Huster et beaucoup d'autres.
         Support profession depuis plus de dix ans pour les médecins suisse
         par Medelexis SA.
  '';
  homepage    = "https://elexis.info/";
  changelog   = "https://github.com/elexis/elexis-3-core/blob/master/Changelog";
#  license     = licenses.epl20;
#    maintainers = with maintainers; [ ngiger ];
#    platforms   = platforms.unix;
  inherit gcc coreutils perl glibc busybox makeWrapper stdenv patchelf  ;
  nativeBuildInputs = [ unzip  ];
  src = elexis-congo/ch.elexis.congo.p2site/target/products/ElexisCongoApp-linux.gtk.x86_64.zip;

  desktopItem = makeDesktopItem {
    name = "${pname}-${version}";
    exec = "${exec}";
    icon = "${icon}";
    comment = "Une application clipse RCP pour les médecins au Congo";
    desktopName = "Elexis Congo";
    genericName = "ElexisCongo";
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
    openjdk11
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
    mkdir -p "$out/app" 
    unzip -qd "$out/app" $src
  '';
  
  phases = [ "unpackPhase" "buildPhase" ] ;
  ldPath = "${lib.makeLibraryPath ([ glib gtk3 xorg.libXtst openjfx11 webkit webkitgtk ])}";
  setElexisEnv =  writeScriptBin "setElexisEnv" ''
      #!${pkgs.stdenv.shell}
#       # Generate a small helper script for running RCPTT test via mvn rpctt plugin
      export LD_LIBRARY_PATH='$ldPath'
      export XDG_DATA_DIRS='${gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-40.0'
      export GIO_EXTRA_MODULES='${glib_networking}/lib/gio/modules'
      export JAVA_HOME='${pkgs.openjdk11}'
  '';
  buildPhase = ''
    # Unpack tarball.
    mkdir -p $out/bin
    cp -v $setElexisEnv/bin/setElexisEnv  $out/bin
    # Patch Elexis3 binary AND the embedded java from the JRE
    interpreter=$(echo ${stdenv.glibc.out}/lib/ld-linux*.so.2)
    patchelf \
    --set-interpreter $interpreter $out/app/Elexis3 \
    --set-rpath $ldPath \
    $out/app/Elexis3
    patchelf --set-interpreter $interpreter $out/app/plugins/*/jre/bin/java
    
    # ensure eclipse.ini does not try to use a justj jvm, as those aren't compatible with nix
    sed -i '/-vm/d' $out/app/Elexis3.ini
    sed -i '/org.eclipse.justj/d' $out/app/Elexis3.ini
    # does not seem to work with webbrowser find $out -name "*justj*" -type d | xargs rm -rf
    
    makeWrapper $out/app/Elexis3 $out/bin/"${exec}-h2_rcptt_fr" \
      --prefix PATH : ${openjdk11}/bin \
      --prefix LD_LIBRARY_PATH : $ldPath \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --add-flags "-nl fr_CH -os linux -ws gtk -arch x86_64 -consoleLog -vmargs \\
          -Dch.elexis.dbFlavor=h2 -Dch.elexis.dbSpec='jdbc:h2:~/elexis/h2_elexis_rcptt_fr/db;AUTO_SERVER=TRUE' \\
          -Dch.elexis.dbUser=sa -Dch.elexis.dbPw=  \\
          -Dch.elexis.firstMandantName=Mustermann -Dch.elexis.firstMandantPassword=elexisTest -Dch.elexis.firstMandantEmail=mmustermann@elexis.info \\
          -Dch.elexis.username=Mustermann -Dch.elexis.password=elexisTest"

# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/p2p/vuze/default.nix wegen swt lib 
  makeWrapper $out/app/Elexis3 $out/bin/${exec} \
      --prefix PATH : ${openjdk11}/bin \
      --prefix LD_LIBRARY_PATH : $ldPath \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --add-flags "-nl fr_CH -os linux -ws gtk -arch x86_64 -consoleLog"
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/p2p/vuze/default.nix wegen swt lib 
  makeWrapper $out/app/Elexis3 $out/bin/"${exec}-demoDB" \
      --run "[[ ! -d ~/elexis/demoDB ]] && ${unzip}/bin/unzip $demoDB -d ~/elexis" \
      --prefix PATH : ${openjdk11}/bin \
      --prefix LD_LIBRARY_PATH : $ldPath \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --add-flags "-nl fr_CH -os linux -ws gtk -arch x86_64 -consoleLog \
      -configuration ~/elexis/.demo_config \
      -vmargs \
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
