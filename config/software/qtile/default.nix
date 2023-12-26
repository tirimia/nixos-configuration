{pkgs, lib, config, ...}:
{
  config = {
    services.xserver.displayManager.defaultSession = "none+qtile";
    services.xserver.windowManager.qtile = {
      enable = true;
      configFile = ./config.py;
      extraPackages = python3Packages: with python3Packages; [
        qtile-extras
      ];
    };
  };
}
