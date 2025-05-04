{ pkgs, ... }:

{
  users.users.kel = {
    description = "Dr. Kellin";
    extraGroups = [
    ];
    isNormalUser = true;
    hashedPasswordFile = "/persistent/passwords/kel";
    shell = pkgs.zsh;
  };
}
