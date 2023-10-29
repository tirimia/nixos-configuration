{
  # TODO: figure out tests and checks
  description = "tirimia NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware"; # Look into getting the fingerprint reader for thinkpads from here
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, ...} @ attrs: let
    nixosMachines = {
      stinkpad = {
        system = "x86_64-linux";
      };
    };
    darwinMachines = {
      emwan.system = "aarch64-darwin";
    };
    username = "tirimia";
  in {
    nixosConfigurations =
      builtins.mapAttrs
      (host: config:
        attrs.nixpkgs.lib.nixosSystem {
          system = config.system;
          modules = [
            {
              _module.args.unstablePkgs = import attrs.unstable {
                inherit (config) system;
                config.allowUnfree = true;
              };
            }
            attrs.home-manager.nixosModules.default
            ./hosts/${host}
            ./users/${username}
          ];
        })
      nixosMachines;
    darwinConfigurations =
      builtins.mapAttrs
      (host: config:
        attrs.darwin.lib.darwinSystem {
          system = config.system;
          modules = [
            {
              _module.args.unstablePkgs = import attrs.unstable {
                inherit (config) system;
                config.allowUnfree = true;
              };
              _module.args.user = username;
            }
            attrs.home-manager.darwinModules.default
            ./hosts/emwan
          ];
        })
      darwinMachines;
  };
}
