{
  self,
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}: let
  username = "tirimia";
  name = "Theodor Irimia";
  email = "theodor.irimia@gmail.com";
in {
  imports = [
    ../../config/software/zsh
    ../../config/software/git.nix
    ../../config/software/emacs
  ];

  # TODO: for window manager, actually use a systemd service if we depend on bars and shizz
  # TODO: use xmonad
  target.user = username;

  users.users.${username} = {
    isNormalUser = true;
    description = name;
    initialPassword = "wouldntyouliketoknowweatherboy";
    extraGroups = ["wheel" "networkmanager" "libvirtd" "docker" "tty"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      home = {
        homeDirectory = "/home/${username}";
        stateVersion = "23.05";
        packages = with pkgs; [
          unstablePkgs.megasync # TODO: run as a service
          _1password
        ];
      };
      programs.home-manager.enable = true;
    };
  };
}
