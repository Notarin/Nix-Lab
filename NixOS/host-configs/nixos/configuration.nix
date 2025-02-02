{ config, pkgs, modules, ... }:

{
  imports = [
    ./boot-loader.nix
    ./packages.nix
    ./hardware-configuration.nix
    ];

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
