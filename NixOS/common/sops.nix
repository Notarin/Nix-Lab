{rootDir, ...}: {
  sops.defaultSopsFile = rootDir + /secrets/vault.yaml;
  sops.age.keyFile = "/persistent/unlock.age";

  sops.secrets."users/notarin" = {
    neededForUsers = true;
  };
  sops.secrets."users/kel" = {
    neededForUsers = true;
  };

  sops.secrets."gitea/notarin" = {};
  sops.secrets."gitea/yinyang" = {};
}
