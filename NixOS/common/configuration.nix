{
  self,
  hostName,
  pkgs,
  ...
}: {
  imports = [
    ./ssh-net.nix
    ./sops.nix
    ./test-vm.nix
  ];

  # Common system options
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = ["notarin"];
  };
  networking = {
    hostName = hostName;
    useDHCP = true;
    networkmanager = {
      wifi.backend = "iwd";
    };
    wireless.iwd.enable = true;
  };
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [self.overlays.topology];
  };
  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    # By default, even unstable isn't up to date
    # Instead there is a separate package for the latest version
    nixVersions.latest
  ];

  # Default user options
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.nushell;
  };

  # Common services
  services = {
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
    hayabusa.enable = true;
  };

  programs.noisetorch.enable = true;
  programs.zsh.enable = true;

  # Generic hardware settings
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
