{
  pkgs,
  lib,
  sshNetPort,
  sshNetServerHost,
  config,
  nixos_hosts,
  ...
}: let
  sshConfigList =
    map (hostAttrs: ''
      Host ${hostAttrs.hostName}
        HostName localhost
        Port ${toString hostAttrs.sshNetPort}
    '')
    nixos_hosts;

  sshConfig = lib.concatStringsSep "\n" sshConfigList;
in {
  systemd.services.sshNet = {
    enable = true;
    description = "A reverse tunnel to the SSH-Net server";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = config.users.users.notarin.name;
      Restart = "always";
      RestartSec = 10;
      ExecStart = "${lib.getExe pkgs.openssh} -NR ${builtins.toString sshNetPort}:localhost:22 ${config.users.users.notarin.name}@${sshNetServerHost}";
    };
  };
  programs.ssh.extraConfig = sshConfig;
}
