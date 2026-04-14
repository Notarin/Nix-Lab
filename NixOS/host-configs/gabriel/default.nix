{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    (self + /Modules/persistence.nix)
    (self + /Users/notarin.nix)
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  #Program configurations
  programs = {
    hyprland.enable = true;
    steam.enable = true;
    gamemode.enable = true;
  };
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

  # Don't touch this
  system.stateVersion = "24.05";
}
