{ hostName, yants, config, pkgs, ... }:

{
  # Common system options
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
  users.mutableUsers = false;

  # Common package options
  users.defaultUserShell = pkgs.nushell;

  # Common services
  services.openssh.enable = true;
  services.openssh.settings.StrictModes = false;

  # Generic hardware settings
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  environment.systemPackages = with pkgs; [
    nixVersions.latest
    wget
    git
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
