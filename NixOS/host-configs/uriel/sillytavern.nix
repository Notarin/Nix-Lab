{
  pkgs,
  lib,
  self,
  config,
  modulesPath,
  ...
}: {
  disabledModules = ["${modulesPath}/services/web-apps/sillytavern.nix"];

  options.services.sillytavern = {
    enable = (lib.mkEnableOption "SillyTavern") // {default = true;}; # True by default is a temporary fix. Will be undone later.
    config = lib.mkOption {
      type = with lib.types; nullOr attrs; # I *could* typecheck it down to the individual field of sillytaverns config, but nah.
      description = "An attrSet of the config values passed to sillytavern.";
    };
    stateDir = lib.mkOption {
      type = lib.types.externalPath;
      description = "Directory holding stateful data for sillytavern.";
      default = "/var/lib/sillytavern";
      example = "/srv/sillytavern";
    };
    configFile = lib.mkOption {
      type = lib.types.path;
      default = pkgs.writers.writeYAML "config.yaml" config.services.sillytavern.config;
      description = "Path to the SillyTavern configuration file.";
    };
    gitPackage = lib.mkPackageOption pkgs "gitMinimal" {};
    package = lib.mkPackageOption pkgs "sillytavern" {};
  };

  config = lib.mkIf config.services.sillytavern.enable {
    systemd.services.sillytavern = {
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];
      description = "SillyTavern local server";
      serviceConfig = {
        Type = "simple";
        User = config.users.users.sillytavern.name;
        Group = config.users.groups.sillytavern.name;
        ExecStart = "${lib.getExe config.services.sillytavern.package} --global=false --configPath ${config.services.sillytavern.configFile}";
        Restart = "always";

        CapabilityBoundingSet = [""];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = config.services.sillytavern.stateDir;
      };
      path = [
        config.services.sillytavern.gitPackage # Added so you can fetch extensions
      ];
    };
    users.users.sillytavern = {
      name = "sillytavern";
      home = config.services.sillytavern.stateDir;
      description = "SillyTavern server user";
      isSystemUser = true;
      group = config.users.groups.sillytavern.name;
      createHome = true;
      homeMode = "755"; # Readable by everyone, writable by user
      shell = pkgs.shadow; # Disables shell access
    };
    users.groups.sillytavern = {};
    networking.extraHosts = lib.mkIf config.services.nginx.enable ''
      127.0.0.1 sillytavern
      ::1 sillytavern
    '';
    services.nginx = {
      enable = true;
      virtualHosts.sillytavern = {
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.sillytavern.config.port}";
        };
      };
    };
    services.sillytavern = {
      gitPackage = pkgs.git; # Sometimes I need to manually use git, and I don't wanna find out a feature is missing.
      package = self.packages.${pkgs.stdenv.system}.sillytavern; # Use my custom not fucked up derivation for sillytavern.
      stateDir = "/srv/sillytavern";
      config = {
        # YAML config is above
        dataRoot = "${config.services.sillytavern.stateDir}/data"; # StateDir
        listen = false; # Disable external listening
        protocol = {
          ipv4 = true;
          ipv6 = true; # IPv6 is disabled by default
        };
        dnsPreferIPv6 = true;
        browserLaunch = {
          enabled = false;
        };
        port = 5111;
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
        allowKeysExposure = true;
      };
    };
  };
}
