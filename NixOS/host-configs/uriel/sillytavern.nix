{
  pkgs,
  lib,
  ...
}: let
  name = "sillytavern";
  home = "/srv/${name}";
  port = 5000;
  config = pkgs.writers.writeYAML "config.yaml" {
    # YAML config is above
    dataRoot = "${home}/data"; # StateDir
    listen = false; # Disable external listening
    protocol = {
      ipv4 = true;
      ipv6 = true; # IPv6 is disabled by default
    };
    dnsPreferIPv6 = true;
    browserLaunch = {
      enabled = false;
    };
    inherit port;
    whitelistMode = true; # Not needed due to firewall, but could be useful eventually
    whitelist = [
      "127.0.0.1"
      "::1"
    ];
    basicAuthMode = false; # Might use later for public sillytavern
    enableUserAccounts = false; # Might use if I go public sillytavern
    logging = {
      enableAccessLog = true; # Default is true, but I like to have it here if I want to configure it
      minLogLevel = 0; # 0 = TRACE, 1 = INFO, 2 = WARN, 3 = ERROR
    };
    thumbnails = {
      enabled = true; # Default is true, but I like to have it here if I want to configure it
      format = "png"; # Default is jpg
    };
    whitelistImportDomains = [
      "localhost"
      "cdn.discordapp.com"
      "files.catbox.moe"
      "raw.githubusercontent.com"
      "char-archive.evulid.cc"
    ];
    enableServerPlugins = false; # I may change in the future
  };
in {
  systemd.services.${name} = {
    wantedBy = ["multi-user.target"];
    description = "SillyTavern local server";
    serviceConfig = {
      Type = "simple";
      User = name;
      Group = name;
      WorkingDirectory = home;
      ExecStart = "${lib.getExe pkgs.sillytavern} --configPath ${config}";
    };
  };
  users.users.${name} = {
    inherit name home;
    description = "SillyTavern server user";
    isSystemUser = true;
    group = name;
    createHome = true;
    homeMode = "755"; # Readable by everyone, writable by user
    shell = pkgs.shadow; # Disables shell access
  };
  users.groups.${name} = {};
  networking.extraHosts = ''
    127.0.0.1 ${name}
    ::1 ${name}
  '';
  services.nginx.virtualHosts."${name}" = {
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString port}";
    };
  };
}
