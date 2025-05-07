{pkgs, ...}: {
  users.users.kel = {
    description = "Dr. Kellin";
    extraGroups = [
    ];
    isNormalUser = true;
    hashedPasswordFile = "/persistent/passwords/kel";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnSAM81oiQ4iIWUl5Dc2iTbFebJXgwX/bepQTPK9NNq shiki@catbox"
    ];
  };
}
