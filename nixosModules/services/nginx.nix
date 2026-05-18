{
  pkgs,
  config,
  ...
}: {
  services.nginx = {
    package = pkgs.angie;
    virtualHosts = {
      "docs.wogo.dev" = {
        locations."/" = {
          proxyPass = "http://localhost:" + (toString config.services.paperless.port);
        };
      };
    };
  };
}
