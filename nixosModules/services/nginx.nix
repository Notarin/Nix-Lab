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
  security.acme = {
    acceptTerms = true;
    defaults.email = "424c414e4b@gmail.com"; # might have to use mine but idkkk
    certs = {
      "squishcat.net" = {
        domain = "*.squishcat.net";
        group = "nginx";
        dnsProvider = "cloudflare";
        credentialsFile = config.sops.secrets."cloudflare-api-token".path;
      };
    };
  };
}
