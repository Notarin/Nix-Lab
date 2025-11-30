{self}: let
  commonModule = ./common;
  host-module_set = import ./host-configs {inherit self;};
  hostsModules = let
    roughHosts = self.inputs.nixpkgs.lib.attrsToList host-module_set;
    listOfParts = builtins.map (host: {${host.name} = [host.value commonModule];}) roughHosts;
    hostSet = builtins.foldl' (acc: elem: acc // elem) {} listOfParts;
  in
    builtins.mapAttrs (name: value: value ++ [{networking.hostName = name;}]) hostSet;
in
  builtins.mapAttrs (_hostName: modules:
    self.inputs.nixpkgs.lib.nixosSystem {
      inherit modules;
      specialArgs = {inherit self;};
    })
  hostsModules
