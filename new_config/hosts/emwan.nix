{ inputs, ... }:
let
  mkSystemPathModule = import ../../lib/mk-system-path-module.nix;
in
{
  flake.darwinConfigurations = {
    trv4374 = inputs.darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
      modules = [
        (mkSystemPathModule inputs.self "/Users/tirimia/git/github.com/tirimia/nixos-configuration")
        inputs.home-manager.darwinModules.default
        inputs.self.modules.darwin.general
        inputs.self.modules.darwin.tirimiaUser
        { system.primaryUser = "tirimia"; }
        inputs.self.modules.darwin.nix-settings
      ];
    };
  };
}
