{
  pkgs,
  lib,
  sshNetPort,
  sshNetServerHost,
  config,
  ...
}:

{
  systemd.services.sshNet = {
    enable = true;
    description = "A reverse tunnel to the SSH-Net server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = config.users.users.notarin.name;
      Restart = "always";
      RestartSec = 10;
      ExecStart = "${lib.getExe pkgs.openssh} -NR ${builtins.toString sshNetPort}:localhost:22 ${config.users.users.notarin.name}@${sshNetServerHost}";
    };
  };
}
