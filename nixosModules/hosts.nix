{
  config,
  lib,
  fn,
  ...
}: {
  options.hosts = let
    inherit (lib.types) lazyAttrsOf nullOr listOf enum submodule strMatching bool;
    inherit (config.types) diskUuidShort diskUuidLong;
    inherit (lib) mkOption;
    inherit (fn) mkOptionByType;
  in
    mkOptionByType (lazyAttrsOf (submodule {
      options = {
        tags = mkOption {
          description = ''
            A list of tags.
            Tags are single words that collectively describe high level intentions of a host.
            When a tag is applied the host will have a configuration regarding the intention applied.
          '';
          type = listOf (enum ["graphical" "gaming" "graphicalTTY" "iso"]);
        };
        users = mkOption {
          description = ''
            A list of the tenants/users to add to this system.
            Tenant must have their user configured separately, this just adds system configuration depending on the user.
          '';
          type = listOf (enum ["notarin" "kel"]);
        };
        diskLayout = mkOptionByType (nullOr (submodule {
          options = {
            boot = mkOptionByType diskUuidShort;
            primary = mkOptionByType diskUuidLong;
            rootSize = mkOption {
              type = strMatching "^[0-9]+G$";
              default = "1G";
            };
            impermanent = mkOption {
              type = bool;
              default = true;
            };
          };
        }));
      };
    }));

  config.hosts = {
    uriel = {
      tags = ["graphical" "gaming"];
      users = ["notarin" "kel"];
      diskLayout = {
        boot = "91E9-B88D";
        primary = "59bbc31f-76ef-428b-bf04-b88f5352c68b";
        impermanent = true;
        rootSize = "8G";
      };
    };
    gabriel = {
      tags = ["graphical" "graphicalTTY"];
      users = ["notarin"];
      diskLayout = {
        boot = "648C-E5B5";
        primary = "8e4f71ac-9ff5-47a0-b9c6-d351ffa238e2";
        rootSize = "3G";
      };
    };
    installer = {
      tags = ["graphical" "iso"];
      users = ["notarin"];
      diskLayout = null;
    };
    self = config.hosts.${config.hostname};
  };
}
