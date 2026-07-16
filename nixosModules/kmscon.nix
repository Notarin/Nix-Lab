{
  lib,
  fn,
  ...
}: {
  services = fn.ifTag "graphicalTTY" {
    kmscon = {
      enable = true;
      # TODO: Reconfigure this to the newer schema
      # fonts = [
      #   {
      #     name = "FiraCode Nerd Font";
      #     package = pkgs.nerd-fonts.fira-code;
      #   }
      # ];
      extraOptions = "--no-mouse";
    };
  };
  specialisation.plainTTY.configuration = fn.ifTag "graphicalTTY" {
    services.kmscon.enable = lib.mkForce false;
  };
}
