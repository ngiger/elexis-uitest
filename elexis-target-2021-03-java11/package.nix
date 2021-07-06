let nixpkgs = import <nixpkgs> {};
    stdenv = nixpkgs.stdenv;
in rec {
  dumb-hello = stdenv.mkDerivation {
    name = "dumb-hello";
    builder = ./builder.sh;
    dpkg = nixpkgs.dpkg;
    src = nixpkgs.fetchurl {
      url = "http://ftp.us.debian.org/debian/pool/main/h/hello-traditional/hello-traditional_2.9-2_amd64.deb";
      sha256 = "u1li40SrJtWeVavsxlSy40cpu8em06eRNEDPXrioya4=";
    };
  };
  full-hello = nixpkgs.buildFHSUserEnv {
    name = "full-hello";
    targetPkgs = pkgs: [ dumb-hello ];
    multiPkgs = pkgs: [ pkgs.dpkg ];
    runScript = "hello";
  };
}
