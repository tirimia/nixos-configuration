{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [];
  options = {};
  config = {
    environment.systemPackages = with pkgs; [
      alejandra
      nixd
    ];
  };
}
