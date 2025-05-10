{rootDir, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./topology.nix
    (rootDir + /Modules/persistence.nix)
    (rootDir + /Users/notarin.nix)
    (rootDir + /Users/kel.nix)
    ./virtual-machines.nix
    ./plex.nix
    ./gitea-runner.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  # Program configurations
  programs = {
    hyprland.enable = true;
    steam.enable = true;
    gamemode.enable = true;
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
