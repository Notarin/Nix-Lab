{
  config,
  lib,
  fn,
  ...
}: {
  options.functions = lib.mkOption {
    description = ''
      Functions for reuse throughout the module system, similar to `lib` or `util`.
      It is recommended to use this option instead of overlaying or extending `lib`.
      `lib` should be predictable and unmodified for several reasons.
      This option is a thin shim to `fn`, available in the modules arguments.
    '';
    type = with lib.types; attrsOf (functionTo raw);
    example = {
      double = x: x + x;
      triple = x: x + x + x;
    };
    default = {};
  };
  config = {
    functions = {
      listHas = match: builtins.any (elem: elem == match);
      ifHost = arg: lib.mkIf (fn.listHas config.networking.hostName (lib.toList arg));
      ifTag = arg: lib.mkIf (fn.listHas arg config.hosts.self.tags);
      ifUser = arg: lib.mkIf (fn.listHas arg config.hosts.self.users);
      mkOptionByType = type: lib.mkOption {inherit type;};
    };
    _module.args.fn = config.functions;
  };
}
