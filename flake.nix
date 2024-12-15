{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    yants = {
      url = "git+https://code.tvl.fyi/depot.git:/nix/yants.git";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, yants, ... }:
    with (import yants.outPath { });
    let
      hosts = [
        "nixos"
      ];
    in
    {
      nixpkgs = nixpkgs;
      nixosConfigurations = nixpkgs.lib.genAttrs hosts (hostName:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            hostName = hostName;
          };
          modules = [
            ./hosts/${hostName}/configuration.nix
            ./hosts/default/configuration.nix
          ];
        }
      );
    };
}
