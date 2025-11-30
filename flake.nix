{
  inputs = {
    nixpkgs.follows = "home-manager/nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    crane.url = "github:ipetkov/crane";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hayabusa = {
      url = "github:Notarin/hayabusa";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };
    snix-bot = {
      url = "github:Notarin/Snix-Bot";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.SHID.follows = "SHID";
      inputs.crane.follows = "crane";
    };
    SHID = {
      url = "github:Notarin/SHID";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    # Pinning my home-manager so I may follow this flake to its nixpkgs
    home-manager = {
      url = "github:Notarin/home-manager";
      # Nuke every input besides exactly what I need
      inputs.home-manager.follows = "";
      inputs.nix-vscode-extensions.follows = "";
      inputs.nixcord.follows = "";
      inputs.snix.follows = "";
      inputs.stylix.follows = "";
      inputs.treefmt-nix.follows = "";
    };
  };

  outputs = {
    nixpkgs,
    self,
    impermanence,
    treefmt-nix,
    sops-nix,
    nix-topology,
    hayabusa,
    snix-bot,
    SHID,
    ...
  }: let
    systems = ["x86_64-linux"];
    buildEachSystem = output: builtins.map output systems;
    buildAllSystems = output: (
      builtins.foldl' nixpkgs.lib.recursiveUpdate {} (buildEachSystem output)
    );
  in
    buildAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.topology
          ];
        };
        treefmt-config = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

        nixos_hosts = nixpkgs.lib.imap0 (_idx: hostName: {
          inherit hostName;
        }) (builtins.attrNames (builtins.readDir ./NixOS/host-configs));
      in {
        packages.x86_64-linux.installer = self.nixosConfigurations.installer.config.system.build.isoImage;
        formatter.${system} = treefmt-config.config.build.wrapper;
        checks.${system}.formatting = treefmt-config.config.build.check self;
        devShells.${system}.default = SHID.devShells.${system}.default;
        nixosConfigurations = builtins.listToAttrs (
          map (
            host: let
              inherit (host) hostName;
            in {
              name = hostName;
              value = nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit self nixos_hosts hostName nix-topology snix-bot system;
                  rootDir = self;
                };
                modules = [
                  ./NixOS/host-configs/${hostName}/configuration.nix
                  ./NixOS/common/configuration.nix
                  impermanence.nixosModules.impermanence
                  sops-nix.nixosModules.sops
                  nix-topology.nixosModules.default
                  hayabusa.nixosModules.default
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
            {inherit (self) nixosConfigurations;}
          ];
        };
      }
    );
}
