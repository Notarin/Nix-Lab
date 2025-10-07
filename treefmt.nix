{
  projectRootFile = ".git/config";
  settings = {
    allow-missing-formatter = false;
  };
  programs = {
    alejandra.enable = true;
    yamlfmt.enable = true;
    mdformat.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
}
