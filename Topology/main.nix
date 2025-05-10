{config, ...}: {
  networks.home = {
    name = "Home LAN";
    cidrv4 = "192.168.86.0/24";
    cidrv6 = "2603:6081:8300:667b::/64";
  };
  networks.internet = {
    name = "The Internet";
    cidrv4 = "0.0.0.0/0";
    cidrv6 = "::/0";
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
          network = "internet";
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
          network = "internet";
          type = "ethernet";
        };
        wan = {
          network = "internet";
          icon = ./assets/icons/coaxial.svg;
          type = "coaxial";
          physicalConnections = [
            {
              node = "isp";
              interface = "*";
            }
          ];
        };
      };
    };
    isp = {
      name = "ISP";
      deviceType = "isp";
      deviceIcon = config.icons.devices.cloud.file;
      hardware.info = "Spectrum";
      interfaces = {
        "*" = {
          icon = ./assets/icons/coaxial.svg;
          network = "internet";
        };
      };
    };
  };
}
