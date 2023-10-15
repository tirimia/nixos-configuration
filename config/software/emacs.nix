{
  config,
  lib,
  pkgs,
  ...
}: {
  services.emacs = {
    enable = true;
    package = pkgs.emacs29;
  };
  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #   }))
  # ];
}
