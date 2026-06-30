{fn, ...}: {
  services = fn.ifHost "uriel" {
    soft-serve = {
      enable = true;
      settings = {
        name = "Soft Serve";
        log_format = "text";
        ssh = {
          listen_addr = ":23231";
          public_url = "ssh://uriel.squishcat.net:23231";
        };
        http = {
          listen_addr = ":23232";
          public_url = "http://uriel.squishcat.net:23232";
        };
        stats.listen_addr = ":23233";
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [9418 23231 23232 23233];
  };
}
