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
        pavucontrol
        playerctl
        rofi
      ];
    };
    programs.nm-applet.enable = true;
    systemd.user.services.pa-applet = {
      enable = true;
      description = "Pulse audio applet";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig.ExecStart = "${pkgs.pa_applet}/bin/pa-applet";
    };
    services.xserver.displayManager.defaultSession = "none+qtile";
    services.xserver.windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages:
        with python3Packages; [
          xlib
          # https://github.com/NixOS/nixpkgs/issues/271610#issuecomment-1837247382
          (qtile-extras.overridePythonAttrs(old: { disabledTestPaths = [ "test/widget/test_strava.py" ]; }))
          pulsectl-asyncio # For PulseVolume
          psutil # For CPU and Memory
        ];
    };
  };
}
