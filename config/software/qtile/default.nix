{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [../mastermenu];
  config = {
    home-manager.users.${config.target.user} = {
      home.file.".config/qtile/config.py".source = ./config.py;
      home.packages = with pkgs; [
        alsa-utils
        playerctl
        rofi
      ];
      services.network-manager-applet.enable = true;
      services.pasystray.enable = true;
    };
    services.xserver.displayManager.defaultSession = "none+qtile";
    services.xserver.windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages:
        with python3Packages; [
          xlib
        ];
    };
  };
}
