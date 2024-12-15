{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./boot-loader.nix
      ./users.nix
      ./packages.nix
    ];

  #Program configurations
  programs.hyprland.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.zsh.enable = true;

  # System Services
  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
