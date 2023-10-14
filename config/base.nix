{
  config,
  lib,
  pkgs,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      git
      curl
      wget
      file
    ];
  };

  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        USB_AUTOSUSPEND = 0;
      };
    };
  };
}
