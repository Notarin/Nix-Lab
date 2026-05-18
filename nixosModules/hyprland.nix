{
  pkgs,
  config,
  lib,
  fn,
  ...
}: {
  programs.hyprland.enable = fn.ifTag "graphical" true;

  xdg.portal = lib.mkIf config.programs.hyprland.enable {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      hyprland.default = ["hyprland" "gtk"];
    };
  };
  services.gnome.gnome-keyring.enable = lib.mkIf config.programs.hyprland.enable true;
  security.pam.services.notarin.enableGnomeKeyring = lib.mkIf config.programs.hyprland.enable true;
}
