# See https://nixos.wiki/wiki/Packaging/Ruby
# A small helper script to get a development version for running RCPTT Tests under NixOS
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    openjdk11
    postgresql
    maven
    which
    libreoffice
    killall
    git
    webkit
    webkitgtk
    openjfx11 # openjfx
  ];
}
