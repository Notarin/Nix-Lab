{
  lib,
  self,
  config,
  ...
}: {
  imports = [
    self.inputs.sops-nix.nixosModules.sops
  ];

  options.users = let
    inherit (builtins) mapAttrs attrNames;
    inherit (lib) types mkOption mkEnableOption filterAttrs;
    inherit (types) attrsOf submodule bool listOf str;
  in {
    users = mkOption {
      type = attrsOf (submodule {
        options.passwordFileIsSops = mkEnableOption "sops-nix for this user";
      });
    };
    sopsUsers = {
      users = mkOption {
        type = attrsOf bool;
        description = "A read-only map of users and whether they are using sops-nix for their password file.";
        readOnly = true;
        default = mapAttrs (_name: user: user.passwordFileIsSops) config.users.users;
      };
      enabledUsers = mkOption {
        type = listOf str;
        description = "A read-only list of users that are using sops-nix for their password file.";
        readOnly = true;
        default = attrNames (filterAttrs (_name: user: user) config.users.sopsUsers.users);
      };
    };
  };

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

    sops.secrets = builtins.listToAttrs (map (name: {
        name = "users/${name}";
        value = {neededForUsers = true;};
      })
      config.users.sopsUsers.enabledUsers);
  };
}
