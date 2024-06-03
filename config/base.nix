{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./software/nix.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment = {
    systemPackages = with pkgs; [
      alacritty
      gnumake
      fd
      vim
      git
      curl
      wget
      file
    ];
  };

  security.sudo.wheelNeedsPassword = false;
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
