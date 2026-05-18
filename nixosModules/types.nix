{lib, ...}: {
  options.types = lib.mkOption {
    description = "Custom options";
    type = with lib.types; attrsOf optionType;
  };
  config.types = with lib.types; rec {
    diskUuidShort = strMatching "^[[:xdigit:]]{4}-[[:xdigit:]]{4}$";
    diskUuidLong = strMatching "^[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}$";
    diskUuid = oneOf [diskUuidShort diskUuidLong];
  };
}
