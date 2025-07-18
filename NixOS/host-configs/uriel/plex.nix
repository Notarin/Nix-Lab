{...}: {
  services.plex = {
    enable = true;
    dataDir = "/srv/plex";
  };
  services.tautulli = {
    enable = true;
    dataDir = "/srv/tautulli";
  };
}
