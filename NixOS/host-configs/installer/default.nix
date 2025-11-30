{
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Hardware support for an installer USB
    (import "${self.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
    # Adding my own user
    "${self}/Users/notarin.nix"
  ];

  # We're gonna assume this is only gonna be used on the typical architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # By default, I use an encrypted secret to authenticate my user.
  # But this is going on a portable disk, where I don't want my master secret stored,
  # So we gotta override some values to make it plain.
  users.users.notarin = {
    # Set up a plain password
    password = lib.mkForce "swarm";
    # Unset the normal encrypted password
    hashedPasswordFile = lib.mkForce null;
  };

  # In case I feel like deploying my home-manager
  users.users.notarin.packages = [pkgs.home-manager];

  # Switch from logging into `nixos` to my user
  services.getty.autologinUser = lib.mkForce "notarin";
  # The normal banner is not needed
  services.getty.helpLine = lib.mkForce "";
}
