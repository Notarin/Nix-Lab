{
  pkgs,
  rootDir,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
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
    ./vaultwarden.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  # Program configurations
  programs = {
    hyprland.enable = true;
    steam.enable = true;
    gamemode.enable = true;
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.notarin.enableGnomeKeyring = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      hyprland.default = ["hyprland" "gtk"];
    };
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
