{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  imports = [
    ../../config/software/emacs
  ];
  target.user = user;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;
  system.defaults = {
    dock.autohide = true;
  };
  users.users.${user}.home = "/Users/${user}";
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
