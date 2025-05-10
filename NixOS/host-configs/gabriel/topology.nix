{...}: {
  topology.self = {
    hardware.info = "My Personal Laptop";
    interfaces.wlan0 = {
      gateways = ["192.168.0.1"];
      addresses = ["192.168.86.244"];
      mac = "74:12:b3:39:de:3f";
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
}
