{
  lib,
  rootDir,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./topology.nix
    (rootDir + /Modules/persistence.nix)
    (rootDir + /Users/notarin.nix)
  ];

  nix = {
    daemonIOSchedClass = lib.mkDefault "idle";
    daemonCPUSchedPolicy = lib.mkDefault "idle";
  };
  # put the service in top-level slice
  # so that it's lower than system and user slice overall
  # instead of only being lower in system slice
  systemd.services.nix-daemon.serviceConfig.Slice = "-.slice";
  # always use the daemon, even executed  with root
  environment.variables.NIX_REMOTE = "daemon";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  #Program configurations
  programs = {
    hyprland.enable = true;
    steam.enable = true;
    gamemode.enable = true;
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
