{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    home-manager.users.${config.target.user} = {
      home = {
        file.".config/mastermenu" = {
          source = ./files;
          recursive = true;
        };
        packages = with pkgs; [
          autorandr
          betterlockscreen
          libnotify
          maim
          rofi
          xclip
          xdotool
        ];
      };
      services = {
        dunst.enable = true;
      };
    };
  };
}
