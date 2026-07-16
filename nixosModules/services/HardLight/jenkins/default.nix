{
  config,
  pkgs,
  ...
}: {
  services = {
    jenkins = {
      enable = true;
      port = 1444;
      prefix = "/ci";
      packages = builtins.attrValues {
        inherit
          (pkgs)
          git
          nushell
          dotnet-sdk_10
          ;
      };
    };
    nginx.virtualHosts = {
      "hl.squishcat.net".locations."${config.services.jenkins.prefix}/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.jenkins.port}";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [1450];
  };
}
