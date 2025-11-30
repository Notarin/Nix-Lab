{self}: let
  ls = self.inputs.nixpkgs.lib.attrsToList (builtins.readDir ./.);
  filtered = builtins.filter (entry: entry.value == "directory") ls;
  #dirs = builtins.map (entry: entry.name) filtered;
  dirs = builtins.foldl' (acc: elem: acc // {${elem.name} = ./. + "/${elem.name}";}) {} filtered;
in
  dirs
