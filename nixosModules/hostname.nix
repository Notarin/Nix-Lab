{
  config,
  lib,
  ...
}: {
  options.hostname = lib.mkOption {
    description = "Alias for config.networking.hostName";
    type = lib.types.str;
  };
  config.networking.hostName = config.hostname;
}
