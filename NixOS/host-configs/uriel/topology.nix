{self, ...}: {
  topology.self = {
    hardware.info = "My Personal Desktop";
    interfaces = {
      eno1 = {
        gateways = ["192.168.0.1"];
        addresses = ["192.168.86.199"];
        mac = "b4:2e:99:a6:4e:f0";
        network = "home";
        type = "ethernet";
        physicalConnections = [
          {
            node = "router";
            interface = "eno1";
          }
        ];
      };
      wlan0 = {
        gateways = ["192.168.0.1"];
        addresses = ["192.168.86.154"];
        mac = "28:7f:cf:a8:67:95";
        network = "home";
        type = "wifi";
        physicalConnections = [
          {
            node = "router";
            interface = "wlan0";
          }
        ];
      };
    };
    services = {
      plex-media-server = {
        name = "Plex Media Server";
        icon = self + /Topology/assets/icons/plex.svg;
      };
    };
  };
}
