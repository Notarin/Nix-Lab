{config, ...}: {
  services.paperless = {
    enable = true;
    dataDir = "/srv/paperless";
    port = 28981;
    address = "0.0.0.0";
    settings = {
      PAPERLESS_URL = "https://docs.wogo.dev";
    };
  };
  networking.firewall.allowedTCPPorts = [config.services.paperless.port];
  networking.firewall.allowedUDPPorts = [config.services.paperless.port];
}
