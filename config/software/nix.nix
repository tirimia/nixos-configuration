{
  pkgs,
  lib,
  config,
  nixpkgs,
  ...
}: {
  imports = [];
  options = {};
  config = {
    environment.systemPackages = [
      nixpkgs.alejandra
    ];
  };
}
