{ lib, rootDir, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (rootDir + /Modules/persistence.nix)
    (rootDir + /Users/notarin.nix)
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  #Program configurations
  programs.hyprland = {
    enable = true;
  };
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  # Impermanence
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/nvme0n1p3 /btrfs_tmp
    if [[ -e /btrfs_tmp/rootfs ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/rootfs)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/rootfs "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/rootfs
    umount /btrfs_tmp
  '';
  fileSystems."/persistent".neededForBoot = true;

  # Don't touch this
  system.stateVersion = "24.05";
}
