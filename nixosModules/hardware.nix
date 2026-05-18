{
  config,
  lib,
  ...
}: {
  networking.useDHCP = lib.mkDefault true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform =
    lib.mkDefault
    {
    }.${
      config.networking.hostName
    } or "x86_64-linux";

  boot.initrd.availableKernelModules =
    {
      uriel = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      gabriel = [
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
    }.${
      config.networking.hostName
    } or [
    ];

  boot.kernelModules =
    {
      uriel = ["kvm-amd"];
      gabriel = ["kvm-intel"];
    }.${
      config.networking.hostName
    } or [
    ];
}
