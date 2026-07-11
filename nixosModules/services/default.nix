{fn, ...}: {
  imports = [
    ./HardLight
    ./nginx.nix
    ./quest.nix
    ./sillytavern.nix
    ./snix-bot.nix
    ./soft-serve.nix
  ];

  services = {
    sillytavern.enable = fn.ifHost "uriel" true;
    nginx.enable = fn.ifHost "uriel" true;
    snix-bot.enable = fn.ifHost "uriel" true;
    VR.enable = fn.ifHost "uriel" true;
    openssh = {
      enable = true;
      settings = {
        PubkeyAuthentication = true;
        PasswordAuthentication = false;
      };
    };
    seatd.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };
  };
}
