{
  self,
  config,
  ...
}: {
  imports = [
    self.inputs.sops-nix.nixosModules.sops
  ];

  config = {
    sops.defaultSopsFile = self + /secrets/vault.yaml;
    sops.age.keyFile =
      if
        (
          if (config.hosts.self.diskLayout != null)
          then config.hosts.self.diskLayout.impermanent
          else false
        )
      then "/persistent/unlock.age"
      else "/unlock.age";

    sops.secrets."users/notarin" = {
      neededForUsers = true;
    };
    sops.secrets."users/kel" = {
      neededForUsers = true;
    };
    sops.secrets."ss14-oauth-secret" = {};
    sops.secrets."oauth2-cookie-secret" = {};
    sops.secrets."cloudflare-api-token" = {};
  };
}
