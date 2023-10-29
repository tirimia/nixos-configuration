{
  pkgs,
  lib,
  config,
  unstablePkgs,
  ...
}: {
  imports = [];
  options = {};
  config = {
    environment.systemPackages = with unstablePkgs; [
      alejandra
      nixd
    ];
  };
}
