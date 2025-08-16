{
  lib,
  config,
  ...
}: {
  virtualisation.vmVariant = {
    users = {
      users = {
        swarm = rec {
          isNormalUser = true;
          initialPassword = "swarm";
          password = initialPassword;
          group = "swarm";
        };
      };
      groups = {
        ${config.virtualisation.vmVariant.users.users.swarm.name} = {};
      };
    };
    environment.persistence."/persistent" = lib.mkForce {};
    #virtualisation.sharedDirectories = {
    #  persistence = let
    #    dir = "/persistent";
    #  in {
    #    source = dir;
    #    target = dir;
    #  };
    #};
  };
}
