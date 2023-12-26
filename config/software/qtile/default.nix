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
    };
    programs.nm-applet.enable = true;
    # services.pasystray.enable = true; # does not work, manual implementation below
    systemd.user.services.pasystray = {
      enable = true;
      description = "Pulse audio systray";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig.ExecStart = "${pkgs.pasystray}/bin/pasystray";
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
