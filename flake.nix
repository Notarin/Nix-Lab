{
  inputs = {
    nixpkgs.follows = "home-manager/nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snix-bot = {
      url = "github:Notarin/Snix-Bot";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "";
      inputs.SHID.follows = "";
    };
    # Pinning my home-manager so I may follow this flake to its nixpkgs
    home-manager = {
      url = "github:Notarin/home-manager";
      # Nuke every input besides exactly what I need
      inputs.home-manager.follows = "";
      inputs.nix-vscode-extensions.follows = "";
      inputs.nixcord.follows = "";
      inputs.stylix.follows = "";
    };
  };

  outputs = {
    nixpkgs,
    self,
    ...
  }: let
    systems = ["x86_64-linux"];
    buildAllSystems = output: builtins.foldl' nixpkgs.lib.recursiveUpdate {} (map output systems);
  in
    nixpkgs.lib.recursiveUpdate (buildAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.${system}.sillytavern = pkgs.callPackage ./packages/sillytavern.nix {};
        formatter.${system} = pkgs.callPackage ./formatter.nix {};
        checks.${system}.formatting = pkgs.callPackage ./formatter.nix {checkDir = self;};
      }
    )) {
      packages.x86_64-linux.installer = self.nixosConfigurations.installer.config.system.build.isoImage;
      nixosConfigurations = {
        uriel = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit self;};
          modules = [
            ./nixosModules
            {hostname = "uriel";}
          ];
        };
        gabriel = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit self;};
          modules = [
            ./nixosModules
            {hostname = "gabriel";}
          ];
        };
        installer = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit self;};
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./nixosModules
            {hostname = "installer";}
          ];
        };
      };
    };
}
