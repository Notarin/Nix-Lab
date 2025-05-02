{ rootDir, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (rootDir + /Modules/persistence.nix)
    (rootDir + /Users/notarin.nix)
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
