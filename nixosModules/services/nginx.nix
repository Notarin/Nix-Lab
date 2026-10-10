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
    defaults.email = "424c414e4b@gmail.com";
    certs = {
      "squishcat.net" = {
        domain = "*.squishcat.net";
        group = "nginx";
        dnsProvider = "cloudflare";
        credentialFiles = {
          CLOUDFLARE_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare-api-token".path;
        };
      };
    };
  };
  sops.secrets."cloudflare-api-token" = {};
}
