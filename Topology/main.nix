{config, ...}: {
  networks.home = {
    name = "Home Network";
    cidrv4 = "192.168.86.0/24";
    cidrv6 = "2603:6081:8300:667b::/64";
  };
  nodes = {
    router = {
      deviceType = "router";
      hardware.info = "Google Mesh Router";
      interfaces = {
        eno1 = {
          addresses = ["192.168.86.1"];
          mac = "b0:e4:d5:65:6a:34";
          network = "home";
          type = "ethernet";
        };
        wlan0 = {
          addresses = ["192.168.86.1"];
          mac = "b0:e4:d5:65:6a:34";
          network = "home";
          type = "wifi";
        };
        wan = {
          addresses = ["174.111.31.103"];
          network = "home";
          type = "ethernet";
          physicalConnections = [
            {
              node = "modem";
              interface = "eth0";
            }
          ];
        };
      };
    };
    modem = {
      deviceType = "modem";
      deviceIcon = config.icons.devices.router.file;
      hardware.info = "Spectrum Modem";
      interfaces = {
        eth0 = {
          type = "ethernet";
        };
      };
    };
  };
}
