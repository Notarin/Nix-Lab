{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { nixpkgs, impermanence, ... }:
    let
      nixos_hosts = builtins.attrNames (builtins.readDir ./NixOS/host-configs);
      modules = import ./Modules/default.nix;
    in {
      modules = modules;
      nixosConfigurations = nixpkgs.lib.genAttrs nixos_hosts (hostName:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            hostName = hostName;
            modules = modules;
          };
          modules = [
            ./NixOS/host-configs/${hostName}/configuration.nix
            ./NixOS/common/configuration.nix
            impermanence.nixosModules.impermanence
          ];
        });
    };
}
