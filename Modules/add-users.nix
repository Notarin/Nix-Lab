tags:
builtins.listToAttrs (map (tag: {
  name = tag;
  value = { isNormalUser = true; } // (import ../Users/${tag}.nix);
}) tags)
