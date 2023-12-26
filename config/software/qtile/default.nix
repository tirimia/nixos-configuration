{pkgs, lib, config, ...}:
{
  config = {
    home-manager.users.${config.target.user}.home.file.".config/qtile/config.py".source = ./config.py;
    services.xserver.displayManager.defaultSession = "none+qtile";
    services.xserver.windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [
        xlib
      ];
    };
  };
}
