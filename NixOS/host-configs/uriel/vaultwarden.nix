{config, ...}: {
  services.vaultwarden = {
    enable = true;
    environmentFile = config.sops.secrets."vaultwarden/env".path;
  };
  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/var/lib/bitwarden_rs"
    ];
  };
  services.nginx.virtualHosts."uriel.squishcat.net" = {
    locations."/vaultwarden" = {
      proxyPass = "http://localhost:8222/";
    };
  };
  networking.firewall.allowedTCPPorts = [80];
}
