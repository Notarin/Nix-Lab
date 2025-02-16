{ hostName, pkgs, ... }:

{
  # Common system options
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "notarin" ];
  };
  networking.hostName = hostName;
  networking = {
    useDHCP = true;
    networkmanager = {
      wifi.backend = "iwd";
    };
  };
  networking.wireless.iwd.enable = true;
  nixpkgs.config.allowUnfree = true;
  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
    nixVersions.latest
  ];

  # Common package options
  users.defaultUserShell = pkgs.nushell;

  # Common services
  services.openssh.enable = true;
  services.openssh.settings.StrictModes = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.seatd.enable = true;

  # Generic hardware settings
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
