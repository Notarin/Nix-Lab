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
    SHID = {
      url = "github:Notarin/SHID";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "";
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
        };
      in {
        packages.x86_64-linux.installer = self.nixosConfigurations.installer.config.system.build.isoImage;
        formatter.${system} = pkgs.callPackage ./formatter.nix {};
        checks.${system}.formatting = pkgs.callPackage ./formatter.nix {checkDir = self;};
        devShells.${system}.default = SHID.devShells.${system}.default;
        nixosConfigurations = import ./NixOS {inherit self;};
      }
    );
}
