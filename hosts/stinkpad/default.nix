# TODO: pass hostname as arg
args @ {
  config,
  lib,
  pkgs,
  inputs,
  home-manager,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../config/base.nix
    ../../config/software/zsh
  ];

  networking = {
    hostName = "stinkpad";
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "alice";
    };
    # TODO: replace with a real window manager
    windowManager = {
      i3.enable = true;
    };
    videoDrivers = ["intel"];
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
  };
  system.stateVersion = "23.05";
}
