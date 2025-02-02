{ hostName, yants, config, pkgs, ... }:

{
  # Common system options
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Common package options
  users.defaultUserShell = pkgs.nushell;

  # Common services
  services.openssh.enable = true;

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
