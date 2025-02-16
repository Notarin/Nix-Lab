{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixVersions.latest
    wget
    hyprland
    kitty
    wezterm
    wofi
    zellij
    git
    zsh
    bat
    eza
    zoxide
    helix
    nushell
    fish
    carapace
    starship
    zoxide
    btop
    nh
  ];
}
