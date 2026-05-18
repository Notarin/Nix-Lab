{
  pkgs,
  lib,
  fn,
  ...
}: {
  # By default, I use an encrypted secret to authenticate my user.
  # But this is going on a portable disk, where I don't want my master secret stored,
  # So we gotta override some values to make it plain.
  users.users.notarin = fn.ifTag "iso" {
    # Set up a plain password
    password = lib.mkForce "swarm";
    # Unset the normal encrypted password
    hashedPasswordFile = lib.mkForce null;
    # In case I feel like deploying my home-manager
    packages = fn.ifTag "iso" [pkgs.home-manager];
  };

  services.getty = fn.ifTag "iso" {
    # Switch from logging into `nixos` to my user
    autologinUser = lib.mkForce "notarin";
    # The normal banner is not needed
    helpLine = lib.mkForce "";
  };
}
