{
  config,
  lib,
  ...
}: {
  options.services.VR.enable = lib.mkEnableOption "VR";
  config = lib.mkIf config.services.VR.enable {
    services = {
      wivrn.enable = true;
      avahi.enable = true;
      monado.enable = true;
      lact.enable = true;
    };
    hardware.amdgpu.overdrive.enable = true;
  };
}
