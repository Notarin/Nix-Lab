{
  lib,
  fn,
  config,
  ...
}: {
  config = lib.mkIf (config.hosts.self.diskLayout != null) {
    fileSystems."/" =
      if config.hosts.self.diskLayout.impermanent
      then {
        device = "none";
        fsType = "tmpfs";
        options = [
          "size=8G"
          "mode=755"
        ];
      }
      else {
        device = "/dev/disk/by-uuid/${config.hosts.self.diskLayout.primary}";
        fsType = "btrfs";
      };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/${config.hosts.self.diskLayout.boot}";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/${config.hosts.self.diskLayout.primary}";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/${config.hosts.self.diskLayout.primary}";
      fsType = "btrfs";
      options = ["subvol=home"];
    };

    fileSystems."/root" = {
      device = "/dev/disk/by-uuid/${config.hosts.self.diskLayout.primary}";
      fsType = "btrfs";
      options = ["subvol=roothome"];
    };

    fileSystems."/persistent" = lib.mkIf config.hosts.self.diskLayout.impermanent {
      device = "/dev/disk/by-uuid/${config.hosts.self.diskLayout.primary}";
      fsType = "btrfs";
      options = ["subvol=persistent"];
      neededForBoot = true;
    };

    fileSystems."/var/lib" = fn.ifHost "uriel" {
      device = "/dev/disk/by-uuid/${config.hosts.self.diskLayout.primary}";
      fsType = "btrfs";
      options = ["subvol=serviceState"];
      neededForBoot = true;
    };

    # External HDD on Uriel
    fileSystems."/mnt/HD2" = fn.ifHost "uriel" {
      device = "/dev/disk/by-uuid/48475dc3-717f-457b-8bf8-49e4ceec6001";
      fsType = "btrfs";
    };
    fileSystems."/etc/nixos" = fn.ifHost "uriel" {
      device = "/dev/disk/by-uuid/48475dc3-717f-457b-8bf8-49e4ceec6001";
      fsType = "btrfs";
      options = ["subvol=NixOS"];
    };
  };
}
