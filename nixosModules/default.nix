{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./services
    ./users
    ./disk.nix
    ./functions.nix
    ./hardware.nix
    ./hostname.nix
    ./hosts.nix
    ./hyprland.nix
    ./iso.nix
    ./kmscon.nix
    ./persistence.nix
    ./sops.nix
    ./steam.nix
    ./types.nix
  ];

  system.stateVersion = "24.05";
  boot.loader.systemd-boot.enable = true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  nixpkgs = {
    config.allowUnfree = true;
  };
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = ["notarin"];
  };
  networking = {
    useDHCP = lib.mkForce true;
    networkmanager = {
      wifi.backend = "iwd";
    };
    wireless.iwd.enable = true;
  };
  time.timeZone = "America/New_York";

  environment.systemPackages = [
    # By default, even unstable isn't up to date
    # Instead there is a separate package for the latest version
    pkgs.nixVersions.latest
  ];

  # Default user options
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.nushell;
  };
  programs.zsh.enable = true;
  # Generic hardware settings
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
