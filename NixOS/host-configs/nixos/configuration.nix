{ config, pkgs, modules, ... }:

{
  imports = [
    ./packages.nix
    ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  # Users
  users.users = modules.add-users [ "notarin" ];

  #Program configurations
  programs.hyprland.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
