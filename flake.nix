{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-topology.url = "github:oddlama/nix-topology";
  };

  outputs = {
    nixpkgs,
    self,
    impermanence,
    flake-utils,
    treefmt-nix,
    sops-nix,
    nix-topology,
    ...
  }:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.topology
          ];
        };
        treefmt-config = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

        # All managed hosts start reverse SSH tunnels to the sshNetServer.
        # This eliminates the need to expose every host to the internet.
        # I call this the "SSH-Net".
        sshNetServerHost = "wogo.dev";
        sshNetPortIndex = 2000 + 1;

        nixos_hosts = nixpkgs.lib.imap0 (idx: hostName: {
          inherit hostName;
          sshNetPort = idx + sshNetPortIndex;
        }) (builtins.attrNames (builtins.readDir ./NixOS/host-configs));
      in {
        formatter.${system} = treefmt-config.config.build.wrapper;
        checks.${system}.formatting = treefmt-config.config.build.check self;
        devShells.${system}.default = pkgs.mkShell {
          shellHook = ''
            oldHookDir=$(git config --local core.hooksPath)

            if [ "$oldHookDir" != "$PWD/.githooks" ]; then
              read -rp "Set git hooks to $PWD/.githooks? (y/n) " answer
              if [ "$answer" = "y" ]; then
                git config core.hooksPath "$PWD"/.githooks
                echo "Set git hooks to $PWD/.githooks"
              else
                echo "Skipping git hooks setup"
              fi
            fi
          '';
        };
        nixosConfigurations = builtins.listToAttrs (
          map (
            host: let
              hostName = host.hostName;
            in {
              name = hostName;
              value = nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit self nixos_hosts hostName sshNetServerHost nix-topology;
                  sshNetPort = host.sshNetPort;
                  rootDir = self;
                };
                modules = [
                  ./NixOS/host-configs/${hostName}/configuration.nix
                  ./NixOS/common/configuration.nix
                  impermanence.nixosModules.impermanence
                  sops-nix.nixosModules.sops
                  nix-topology.nixosModules.default
                ];
              };
            }
          )
          nixos_hosts
        );
        overlays.topology = nix-topology.overlays.default;
        topology.${system} = import nix-topology {
          inherit pkgs;
          modules = [
            ./Topology/main.nix
            {nixosConfigurations = self.nixosConfigurations;}
          ];
        };
      }
    );
}
