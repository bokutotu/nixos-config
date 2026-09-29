{ profiles, ... }:

{
  imports = [
    ./hardware-configuration.nix
    profiles.dev-shell
    profiles.desktop
    profiles.nvidia
  ];

  networking.networkmanager.enable = true;

  services.libinput.touchpad = {
    tapping = true;
    naturalScrolling = true;
  };

  services.power-profiles-daemon.enable = false;

  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  hardware.nvidia = {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager.users.hikaru._module.args.configurationName = "laptop";

  system.stateVersion = "25.11";
}
