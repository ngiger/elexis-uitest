# https://github.com/nix-community/elexis-all/blob/master/flake.nix
# https://github.com/Mic92/nix-ld
{
  description = "elexis-all - Eclipse RCP app with all opensource components";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs}: let
    forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux"]; # "x86_64-darwin" "i686-linux" "aarch64-linux" ];
  in {
    # Packages
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
      version = "3.8";
    in {
      elexis-all = pkgs.stdenv.mkDerivation {
        name = "elexis-all";
        src = builtins.fetchurl {                                                                                                                                                                            
              url    = "https://download.elexis.info/elexis/${version}/products/Elexis3-linux.gtk.x86_64.zip";                                                                                                                              
              sha256 = "0vx1smknnmqid8n6yqlvd0xhr23cd6cm3kgyr7hlia9v714f5snf";                                                                                                                          
            };

        meta.description = "An Eclipse RCP application for all aspect of a Swiss German medical practice";
        unpackPhase = "true";
        nativeBuildInputs = [ pkgs.makeWrapper pkgs.unzip pkgs.stdenv pkgs.patchelf];
        buildCommand = ''
    # Unpack tarball.
    mkdir -p $out
    unzip -d $out $src
    # Patch binaries.
    interpreter=$(echo ${pkgs.stdenv.glibc.out}/lib/ld-linux*.so.2)
    patchelf --set-interpreter $interpreter $out/Elexis3
    makeWrapper $out/Elexis3 $out/bin/Elexis3 \
      --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath ([ pkgs.glib pkgs.gtk3 pkgs.gtk3-x11 pkgs.xorg.libXtst pkgs.webkitgtk ])} \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --add-flags "-configuration \$HOME/.eclipse/''${productId}_$productVersion/configuration"


'';
      };
    });
    defaultPackage = forAllSystems (system: self.packages."${system}".elexis-all);

    devShell = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
    in pkgs.mkShell {
      buildInputs = with pkgs; [ jq coreutils findutils ];
    });

    # Make it runnable with `nix app`
    apps = forAllSystems (system: {
      elexis3 = {
        type    = "app";
        program = "${self.packages."${system}".elexis-all}/bin/elexis3";
      };
    });
    defaultApp = forAllSystems (system: self.apps."${system}".elexis3);
  };
}
