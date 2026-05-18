{fn, ...}: {
  programs = fn.ifTag "gaming" {
    steam.enable = true;
    gamemode.enable = true;
  };
}
