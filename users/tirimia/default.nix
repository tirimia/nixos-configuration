args @ {
  self,
  config,
  lib,
  pkgs,
  home-manager,
  ...
}: let
  username = "tirimia";
  enhancedArgs = args // {inherit username;};
in {
  imports = [
    home-manager.nixosModules.default
    # ../../config/software/i3
    (import ../../config/software/zsh enhancedArgs)
    ../../config/software/emacs.nix
  ];
  # TODO: for window manager, actually use a systemd service if we depend on bars and shizz
  # TODO: use xmonad

  users.users.${username} = {
    isNormalUser = true;
    description = "Theodor Irimia";
    initialPassword = "wouldntyouliketoknowweatherboy";
    extraGroups = ["wheel" "networkmanager" "libvirtd" "docker" "tty"];
    shell = "/run/current-system/sw/bin/zsh";
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      home = {
        homeDirectory = "/home/${username}";
        stateVersion = "23.05";
      };
      programs.home-manager.enable = true;
    };
  };
}
