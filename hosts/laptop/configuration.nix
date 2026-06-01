{ config, lib, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;
  environment.lxqt.excludePackages = with pkgs; [
    xscreensaver
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        serif = [
          "Noto Serif"
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];
  };

  hardware.graphics.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

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

  services.xserver.videoDrivers = [  "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://cache.iog.io"
    ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "cache.iog.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  programs.fish.enable = true;

  virtualisation.docker.enable = true;

  users.users.hikaru = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "docker" ];
  };

  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Tokyo";

  environment.systemPackages = with pkgs; [
    xorg.xrandr
    xsecurelock
    docker
    k3d
    kubectl
    kubernetes-helm
    tilt
    k9s
  ];

  system.stateVersion = "25.11"; # Did you read the comment?

}
