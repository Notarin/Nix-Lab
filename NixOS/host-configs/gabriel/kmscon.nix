{
  pkgs,
  lib,
  ...
}: {
  services = {
    kmscon = {
      enable = true;
      fonts = [
        {
          name = "FiraCode Nerd Font";
          package = pkgs.nerd-fonts.fira-code;
        }
      ];
      extraOptions = "--no-mouse";
    };
  };
}
