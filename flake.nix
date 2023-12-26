{
  # TODO: figure out tests and checks
  description = "tirimia NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";

    nixos-hardware.url = "github:nixos/nixos-hardware"; # Look into getting the fingerprint reader for thinkpads from here
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, ...} @ attrs: let
    overlays = [
      (import attrs.rust-overlay)
    ];
    nixosMachines = {
      stinkpad = {
        system = "x86_64-linux";
      };
    };
    darwinMachines = {
      Theodor-Irimia-s-MacBook-Pro = {
        alias = "emwan";
        system = "aarch64-darwin";
      };
    };
    username = "tirimia";
  in {
    nixosConfigurations =
      builtins.mapAttrs
      (host: config: let
        pkgs = import attrs.nixpkgs {
          inherit (config) system;
          inherit overlays;
          config.allowUnfree = true;
        };
      in
        attrs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = config.system;
          modules = [
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
              _module.args.pkgs = import attrs.nixpkgs {
                inherit (config) system;
                inherit overlays;
                config.allowUnfree = true;
              };
              _module.args.user = username;
            }
            attrs.home-manager.darwinModules.default
            ./hosts/${config.alias}
          ];
        })
      darwinMachines;
  };
}
