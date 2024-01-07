{
  # TODO: figure out tests and checks
  description = "tirimia NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";

    nixos-hardware.url = "github:nixos/nixos-hardware"; # Look into getting the fingerprint reader for thinkpads from here
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Other versions are broken
    nix-linter.url = "github:NixOS/nixpkgs/4c3c80df545ec5cb26b5480979c3e3f93518cbe5";
  };
  outputs = {
    self,
    darwin,
    ...
  } @ attrs: let
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
    systems = ["aarch64-darwin" "x86_64-linux"];
    pkgsFor = system:
      import attrs.nixpkgs {
        overlays = [
          (import attrs.rust-overlay)
          (final: prev: {
            inherit (attrs.nix-linter.legacyPackages.${system}) nix-linter;
          })
        ];
        inherit system;
        config.allowUnfree = true;
      };
  in {
    formatter = attrs.nixpkgs.lib.attrsets.genAttrs systems (
      system: (import attrs.nixpkgs {inherit system;}).alejandra
    );
    nixosConfigurations =
      builtins.mapAttrs
      (host: config:
        attrs.nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor config.system;
          inherit (config) system;
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
          pkgs = pkgsFor config.system;
          inherit (config) system;
          modules = [
            {
              _module.args.user = username;
            }
            attrs.home-manager.darwinModules.default
            ./hosts/${config.alias}
          ];
        })
      darwinMachines;
  };
}
