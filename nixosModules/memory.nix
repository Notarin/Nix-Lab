{
  config = {
    systemd.oomd = {
      enable = true; # Noop, staking default
      # Allow oomd to kill user processes when it is urgently needed.
      enableUserSlices = true;
      # Probably a poor idea, but hopefully it will only kill robust services.
      enableSystemSlice = true;
    };
    # Compress memory on the fly to free up extra room.
    zramSwap.enable = true;
  };
}
