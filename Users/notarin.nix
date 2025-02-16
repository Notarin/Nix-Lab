{ config, inputs, ... }:

{
  users.users.notarin = {
    description = "Notarin Steele";
    extraGroups = [ "networkmanager" "wheel" ];
    isNormalUser = true;
    hashedPasswordFile = "/persistent/passwords/notarin";
  };
}
