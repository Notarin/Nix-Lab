{ pkgs, ... }:
{
  users.users.notarin = {
    isNormalUser = true;
    description = "Notarin Steele";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      home-manager
    ];
    shell = pkgs.nushell;
  };
}