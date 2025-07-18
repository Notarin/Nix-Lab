{...}: {
  services.paperless = {
    enable = true;
    dataDir = "/srv/paperless";
    port = 28981;
  };
}
