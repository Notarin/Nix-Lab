{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      self,
      impermanence,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let
        # All managed hosts start reverse SSH tunnels to the sshNetServer.
        # This eliminates the need to expose every host to the internet.
        # I call this the "SSH-Net".
        sshNetServerHost = "wogo.dev";
        sshNetPortIndex = 2000 + 1;

        nixos_hosts = nixpkgs.lib.imap0 (idx: hostName: {
          inherit hostName;
          sshNetPort = idx + sshNetPortIndex;
        }) (builtins.attrNames (builtins.readDir ./NixOS/host-configs));

      in
      {
        nixosConfigurations = builtins.listToAttrs (
          map (
            host:
            let
              hostName = host.hostName;
            in
            {
              name = hostName;
              value = nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit hostName sshNetServerHost;
                  sshNetPort = host.sshNetPort;
                  rootDir = self;
                };
                modules = [
                  ./NixOS/host-configs/${hostName}/configuration.nix
                  ./NixOS/common/configuration.nix
                  impermanence.nixosModules.impermanence
                ];
              };
            }
          ) nixos_hosts
        );
      }
    );
}
