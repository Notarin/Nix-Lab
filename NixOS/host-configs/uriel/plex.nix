{...}: {
  services.plex = {
    enable = true;
    dataDir = "/srv/plex";
    group = "users";
  };
}
