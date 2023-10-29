{ config, lib, pkgs, user, ...}:
{
  imports = [
    ../../config/software/emacs
  ];
  target.user = user;
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  system.defaults = {
    dock.autohide = true;
  };
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${user} = {
      home = {
        stateVersion = "23.05";
      };
    };
  };
}
