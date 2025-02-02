let
  moduleFiles = builtins.filter (file: builtins.match ".*\\.nix" file != null) (builtins.attrNames (builtins.readDir ./.));
  modules = builtins.listToAttrs (map (file: {
    name = builtins.replaceStrings [".nix"] [""] file;
    value = import ./${file};
  }) moduleFiles);
in
  modules