# see https://serokell.io/blog/practical-nix-flakes
# nix build .#hello
# nix run .#hello
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils}:
      let version = "0.9.5561"; 
      in {
        packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
        packages.x86_64-linux.datomic = derivation   {
          buildInputs = [
  nixpkgs.legacyPackages.x86_64-linux.fontconfig
nixpkgs.legacyPackages.x86_64-linux.freetype
nixpkgs.legacyPackages.x86_64-linux.glib
nixpkgs.legacyPackages.x86_64-linux.gsettings-desktop-schemas
nixpkgs.legacyPackages.x86_64-linux.jdk
nixpkgs.legacyPackages.x86_64-linux.makeWrapper
nixpkgs.legacyPackages.x86_64-linux.zlib
nixpkgs.legacyPackages.x86_64-linux.webkitgtk
# nixpkgs.legacyPackages.x86_64-linux.gtk
# nixpkgs.legacyPackages.x86_64-linux.libX11
# nixpkgs.legacyPackages.x86_64-linux.libXrender
# nixpkgs.legacyPackages.x86_64-linux.libXtst
  ] ;

            name    = "datomic-${version}";
            system  = "x86_64-linux";
            builder = "${nixpkgs.legacyPackages.x86_64-linux.bash}/bin/bash"; args = [ ./builder.sh ];
            src = builtins.fetchurl {                                                                                                                                                                            
              url    = "https://my.datomic.com/downloads/free/${version}";                                                                                                                              
              sha256 = "145c3yx9ylmvvxmwgk2s14cdirxasdlglq3vs9qsnhyaz5jp1xjh";                                                                                                                          
            };
        };
      };
}
