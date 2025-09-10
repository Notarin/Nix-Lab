{
  pkgs,
  lib,
  snix-bot,
  system,
  config,
  ...
}: let
  package = snix-bot.packages.${system}.default;
  name = "snix-bot";
  home = "/srv/${name}";
  tokenFile = config.sops.secrets."snix-bot/token".path;
in {
  sops.secrets."snix-bot/token" = {
    owner = name;
    group = name;
  };
  systemd.services.${name} = {
    wantedBy = ["multi-user.target"];
    description = "The Nix discord bot.";
    serviceConfig = {
      Type = "simple";
      User = name;
      Group = name;
      WorkingDirectory = home;
      ExecStart = lib.getExe (pkgs.writers.writeBashBin "snix-bot" ''
        export TOKEN="$(cat ${tokenFile})"
        ${lib.getExe package}
      '');
    };
    path = [];
  };
  users.users.${name} = {
    inherit name home;
    description = "snix-bot host user.";
    isSystemUser = true;
    group = name;
    createHome = true;
    homeMode = "755"; # Readable by everyone, writable by user
    shell = pkgs.shadow; # Disables shell access
  };
  users.groups.${name} = {};
}
