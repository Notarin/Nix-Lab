{
  pkgs,
  config,
  fn,
  ...
}: {
  users.users.kel = {
    enable = fn.ifUser config.users.users.kel.name true;
    description = "Dr. Kellin";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/kel".path;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnSAM81oiQ4iIWUl5Dc2iTbFebJXgwX/bepQTPK9NNq shiki@catbox"
    ];
  };
}
