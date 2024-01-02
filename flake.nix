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
    systems = ["aarch64-darwin" "x86_64-linux"];
    pkgsFor = system:
      import attrs.nixpkgs {
        inherit overlays system;
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
          pkgs = pkgsFor config.system;
          system = config.system;
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
