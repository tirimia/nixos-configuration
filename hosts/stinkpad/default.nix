{
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
    ../../config/fonts.nix
  ];

  networking = {
    hostName = "stinkpad";
    networkmanager.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  programs.direnv.enable = true;
  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
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

  console.keyMap = "de";
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    vim
    usbutils
    arandr
  ];

  system.stateVersion = "23.11";
}
