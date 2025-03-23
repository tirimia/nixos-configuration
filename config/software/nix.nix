{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ];
  options = { };
  config = {
    nix.settings.substituters = [
      "https://nix-community.cachix.org"
    ];

    nix.settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    environment.systemPackages = with pkgs; [
      alejandra
      nix-linter
      nixd
    ];
  };
}
