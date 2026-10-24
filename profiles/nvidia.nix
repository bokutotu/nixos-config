{ config, lib, unstablePkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    open = lib.mkDefault true;
    nvidiaSettings = lib.mkDefault config.services.xserver.enable;
    package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker = {
    enableNvidia = true;
    daemon.settings.features.cdi = true;
  };

  environment.systemPackages = [ unstablePkgs.cudaPackages.cudatoolkit ];
}
