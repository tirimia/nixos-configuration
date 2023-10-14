# TODO: actually write this
{
  callPackage,
  config,
  lib,
  pkgs,
  ...
}: {
  services.emacs = {
    enable = true;
    package = pkgs.emacs-unstable;
  };
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
}
