{
  pkgs,
  lib,
  fn,
  ...
}: {
  services = fn.ifTag "graphicalTTY" {
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
  specialisation.plainTTY.configuration = fn.ifTag "graphicalTTY" {
    services.kmscon.enable = lib.mkForce false;
  };
}
