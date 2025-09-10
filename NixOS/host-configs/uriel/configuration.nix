{rootDir, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./topology.nix
    (rootDir + /Modules/persistence.nix)
    (rootDir + /Users/notarin.nix)
    (rootDir + /Users/kel.nix)
    ./nginx.nix
    ./virtual-machines.nix
    ./plex.nix
    ./gitea-runner.nix
    ./paperless.nix
    ./ollama.nix
    ./sillytavern.nix
    ./snix-bot.nix
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
