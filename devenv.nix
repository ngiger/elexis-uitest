{
  pkgs,
  config,
  ...
}: {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [
    pkgs.curl
    pkgs.git
    pkgs.glib
    pkgs.gtk3
    pkgs.killall
    pkgs.libsecret
    pkgs.openbox
    pkgs.openjdk21
    pkgs.ruby
    pkgs.temurin-jre-bin # see https://github.com/NixOS/nixpkgs/issues/376697
    pkgs.rsync
    pkgs.steam-run
    pkgs.swt
    pkgs.webkitgtk_4_1
    pkgs.xorg.libX11
    pkgs.xorg.libXext
    pkgs.xorg.libXi
    pkgs.xorg.libXrender
    pkgs.xorg.libXtst
    pkgs.xvfb-run
    pkgs.zlib
    pkgs.nss # Needed for chromium plugin
  ];

  env.RCPTT_URL = "https://download.eclipse.org/rcptt/nightly/2.6.0/latest/ide/rcptt.ide-2.6.0-nightly-linux.gtk.x86_64.zip";
  env.RCPTT_ZIP = "rcptt.ide-2.6.0.zip";

  enterShell = ''
    git --version
    rsync -av setup/data/ ~/elexis/rcptt/
    if [ ! -f ${config.env.RCPTT_ZIP} ]; then
      echo Must download the file ${config.env.RCPTT_URL}
      ${pkgs.curl}/bin/curl -o ${config.env.RCPTT_ZIP} ${config.env.RCPTT_URL}
    else
      echo I am testing whether I have to update ${config.env.RCPTT_ZIP}
      ${pkgs.curl}/bin/curl --silent -z ${config.env.RCPTT_ZIP} ${config.env.RCPTT_URL}
    fi
    unzip -o -u ${config.env.RCPTT_ZIP}
  '';
  scripts.rcptt.exec = ''
    ${pkgs.steam-run-free}/bin/steam-run rcptt/rcptt -data rcptt-ws
  '';

  services.postgres.enable = true;
  services.postgres.listen_addresses = "127.0.0.1"; # "0.0.0.0"; # on all available IPv4 network interfaces
  services.postgres.initialDatabases = [
    {name = "elexis_rcptt_de"; pass="elexisTest";}
    {name = "elexis_rcptt_fr"; pass="elexisTest";}
    {name = "elexis_rcptt_it"; pass="elexisTest";}
    {name = "elexis"; pass="elexisTest";}
  ];
  services.postgres.initialScript = ''
    drop USER if exists elexis;
    CREATE USER elexis WITH PASSWORD 'elexisTest';
    ALTER USER elexis WITH SUPERUSER;
    CREATE ROLE niklaus SUPERUSER;
  '';
  services.mysql.initialDatabases = [
    {name = "elexis_rcptt_de";}
    {name = "elexis_rcptt_fr";}
    {name = "elexis_rcptt_it";}
    {name = "elexis";}
  ];
  services.mysql.enable = true;
  services.mysql.ensureUsers = [
    {
      name = "elexis";
      password = "elexisTest";
      ensurePermissions = {
        "database.*" = "ALL PRIVILEGES";
        "elexis.*" = "ALL PRIVILEGES";
        "elexis_rcptt_de.*" = "ALL PRIVILEGES";
        "elexis_rcptt_fr.*" = "ALL PRIVILEGES";
        "elexis_rcptt_it.*" = "ALL PRIVILEGES";
      };
    }
  ];

}
