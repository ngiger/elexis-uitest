#!/usr/bin/env nix-shell
# call it: nix-shell start_eclipse.nix
with import <nixpkgs> {};
mkShell {
  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
    zlib
    dbus
    git
    glib
    glib-networking
    gnulib
    gsettings-desktop-schemas
    gtk3
    gvfs
    jdk11
    librsvg
    libsecret
    libzip
    openssl
    stdenv
    stdenv.cc.cc
    unzip
    webkitgtk
    xorg.libXext # avoids libawt_xawt.so: libXext.so.6: cannot open shared object file: No such file or directory
    xorg.libX11
    xorg.libXtst
    xorg.libXrender
    xorg.libXi
  ];
  NIX_LD = builtins.readFile "${stdenv.cc}/nix-support/dynamic-linker";
  shellHook = ''
    echo in shellHook;
    export version=`echo ${gtk3}  | cut -d '-' -f 3`
    export GIO_MODULE_DIR=${glib-networking}/lib/gio/modules/
    export GDK_BACKEND=wayland 
    echo GDK_BACKEND are $GDK_BACKEND and GIO_MODULE_DIR are $GIO_MODULE_DIR
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:${gtk3}/share/gsettings-schemas/gtk+3-$version" # this worked! Tested using File..Open
    export GIO_EXTRA_MODULES=${glib-networking}/lib/gio/modules
    echo GIO_EXTRA_MODULES are $GIO_EXTRA_MODULES
    echo done shellHook version is $version
  '';
}
