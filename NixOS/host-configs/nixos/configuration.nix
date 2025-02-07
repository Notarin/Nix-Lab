{ config, pkgs, modules, inputs, ... }:

{
  imports = [
    ./packages.nix
    ./hardware-configuration.nix
    ./persistence.nix
    ../../../Users/notarin.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  #Program configurations
  programs.hyprland.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Don't touch this
  system.stateVersion = "24.05";
}
