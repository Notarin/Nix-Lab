{
  pkgs,
  config,
  ...
}: {
  services.nginx = let
    hostname = "wogo.dev";
  in {
    enable = true;
    package = pkgs.angie;
    virtualHosts = {
      "docs.${hostname}" = {
        locations."/" = {
          proxyPass = "http://localhost:" + (builtins.toString config.services.paperless.port);
        };
      };
      "ollama.${hostname}" = {
        locations."/" = {
          proxyPass = "http://localhost:" + (builtins.toString config.services.ollama.port);
        };
      };
    };
  };
}
