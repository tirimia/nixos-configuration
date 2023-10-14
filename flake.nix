{
  # TODO: figure out tests and checks
  # https://github.com/Baitinq/nixos-config/blob/master/flake.nix
  description = "tirimia NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:nixos/nixos-hardware"; # Look into getting the fingerprint reader for thinkpads from here
    emacs.url = "github:nix-community/emacs-overlay";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ attrs: let
    machines = {
      stinkpad = {
        system = "x86_64-linux";
      };
    };
    username = "tirimia";
  in {
    nixosConfigurations =
      builtins.mapAttrs
      (host: config:
        nixpkgs.lib.nixosSystem {
          system = config.system;
          specialArgs = attrs;
          modules = [
            ./hosts/${host}
            ./users/${username}
          ];
        })
      machines;
  };
}
