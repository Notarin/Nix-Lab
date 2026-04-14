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
  specialisation.plainTTY.configuration = {
    services.kmscon.enable = lib.mkForce false;
  };
}
