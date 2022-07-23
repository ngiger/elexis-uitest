# Helper to add RCPTT to a NixOS system, must be installed using the following steps
# mvn -V clean -f verify elexis-master/pom.xml
# nix-build rcptt.nix; nix-env -i result/
with (import <nixpkgs> {}); let
  pname = "RCPTT";
  version = "2.5.1";
  exec = "rcptt";
in
  stdenv.mkDerivation {
    name = "${pname}-${version}";
    exec = "${exec}";
    description = "RCP Testing Tool";
    longDescription = ''
      RCP Testing Tool is a project for GUI testing automation of Eclipse-based applications.
      RCPTT is fully aware about Eclipse Platform\'s internals, hiding this complexity
      from end users and allowing QA engineers to create highly reliable UI tests at great pace.
    '';
    homepage = "https://www.eclipse.org/rcptt";
    #    license = licenses.epl20;

    # license     = licenses.epl2;
    #    maintainers = with maintainers; [ ngiger ];
    #    platforms   = platforms.unix;
    inherit gcc coreutils perl glibc busybox makeWrapper stdenv patchelf;
    nativeBuildInputs = [unzip];
    src = fetchurl {
      url = "http://download.eclipse.org/rcptt/release/2.5.1/ide/rcptt.ide-2.5.1-linux.gtk.x86_64.zip";
      sha256 = "sha256-9P2foVEbhH7IsdHZ6h6dQNvoIZwXmVAice9ac0w/KwY=";
    };

    desktopItem = makeDesktopItem {
      name = "${pname}-${version}";
      exec = "${exec}";
      icon = "rcptt";
      comment = "RCP Testing Tool";
      desktopName = "RCPTT";
      genericName = "RCPTT";
      categories = "Development;";
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
      xorg.libX11
      xorg.libXrender
      xorg.libXtst
      zlib
    ];
    unpackPhase = ''
      mkdir -pv "$out/rcptt"
      unzip -qd $out $src
    '';

    phases = ["unpackPhase" "buildPhase"];
    ldPath = "${lib.makeLibraryPath [glib gtk2 xorg.libXtst openjfx11 webkit webkitgtk]}";
    buildPhase = ''
      # Unpack tarball.
      mkdir -pv $out/bin
      interpreter=$(echo ${stdenv.glibc.out}/lib/ld-linux*.so.2)
      patchelf \
      --set-interpreter $interpreter $out/rcptt/rcptt \
      --set-rpath $ldPath \
      $out/rcptt/rcptt
      makeWrapper $out/rcptt/rcptt $out/bin/${exec} \
        --prefix LD_LIBRARY_PATH : $ldPath \
        --add-flags "-debug -consoleLog"

      # copy icon
      mkdir -p  $out/share/pixmaps
      ln -s $out/rcptt/icon.xpm $out/share/pixmaps/rcptt.xpm
      # Create desktop items
      mkdir -p $out/share/applications
      cp $desktopItem/share/applications/* $out/share/applications
    '';
    system = builtins.currentSystem;
  }
