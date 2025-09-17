{ inputs, ... }:
{
  flake.darwinConfigurations = {
    emwan = inputs.darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
      modules = [
        inputs.home-manager.darwinModules.default
        inputs.self.modules.darwin.general
        inputs.self.modules.darwin.tirimiaUser
        { system.primaryUser = "tirimia"; }
        inputs.self.modules.darwin.nix-settings
      ];
    };
  };
}
