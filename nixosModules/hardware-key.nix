{pkgs, ...}: {
  services.pcscd.enable = true;

  services.udev.packages = [
    pkgs.yubikey-personalization
    pkgs.libfido2
  ];

  environment.systemPackages = [
    pkgs.yubioath-flutter
  ];
}
