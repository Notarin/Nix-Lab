{ hostName, yants, config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
}
