{pkgs, ...}: {
  imports = [../mastermenu];
  config = {
    environment.systemPackages = with pkgs; [
      alsa-utils
      pavucontrol
      playerctl
      rofi
    ];
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
      configFile = ./config.py;
      extraPackages = import ./qtilePackages.nix;
    };
  };
}
