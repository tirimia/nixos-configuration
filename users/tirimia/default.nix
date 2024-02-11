{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  username = "tirimia";
  name = "Theodor Irimia";
in {
  imports = [
    ../../config/software/zsh
    ../../config/software/git.nix
    ../../config/software/emacs
  ];

  target.user = username;

  users.users.${username} = {
    isNormalUser = true;
    description = name;
    initialPassword = "wouldntyouliketoknowweatherboy";
    extraGroups = ["wheel" "networkmanager" "libvirtd" "docker" "tty"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      home = {
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
        packages = with pkgs; [
          megasync # TODO: run as a service
          _1password
        ];
      };
      programs.home-manager.enable = true;
    };
  };
}
