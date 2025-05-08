{config, ...}: {
  users.users.notarin = {
    description = "Notarin Steele";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/notarin".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFU1sdK5nNgNhCFusMYY61FXMDD8+Hws+igIgAOb7xpg notarin@uriel"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFpUz7+oWy492j1T6es6274g3cADuQEuANx3lNEy6I7d notarin@gabriel"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcxVq5W1Rs3Hk1sTvakwt/Hmug1gIkuo62yKwD0iMw/ JuiceSSH"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHQs62gxckea4wnA0DZI9nauzq7fh/nEgpRIMJiKJigjAAAADHNzaDp3b2dvLmRldg== notarin@arch"
    ];
  };
}
