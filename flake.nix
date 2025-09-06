{
  description = "tirimia NixOS configs";

  nixConfig = {
    extra-trusted-substituters = [ "https://cache.flox.dev" ];
    extra-trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # emacs-overlay.url = "github:nix-community/emacs-overlay";
    # emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Other versions are broken
    nix-linter.url = "github:NixOS/nixpkgs/4c3c80df545ec5cb26b5480979c3e3f93518cbe5";

    tree-sitter-astro = {
      url = "github:virchau13/tree-sitter-astro";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flox.url = "github:flox/flox";
  };
  outputs =
    inputs:
    let
      nixosMachines = {
        stinkpad = {
          system = "x86_64-linux";
        };
      };
      darwinMachines = {
        trv3692 = {
          alias = "emwan";
          system = "aarch64-darwin";
        };
      };
      username = "tirimia";
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      pkgsFor =
        system:
        import inputs.nixpkgs {
          overlays = [
            # inputs.emacs-overlay.overlays.default
            inputs.rust-overlay.overlays.default
            inputs.tree-sitter-astro.overlays.default
            (final: prev: {
              inherit (inputs.nix-linter.legacyPackages.${system}) nix-linter;
            })
            (final: prev: {
              inherit (inputs.flox.packages.${system}) flox;
            })
            (final: prev: {
              kotlin-lsp = final.callPackage ./temporary_recipes/kotlin-lsp.nix { };
            })
          ];
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      formatter = inputs.nixpkgs.lib.attrsets.genAttrs systems (
        system: (import inputs.nixpkgs { inherit system; }).nixfmt-rfc-style
      );
      nixosConfigurations = builtins.mapAttrs (
        host: config:
        inputs.nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor config.system;
          inherit (config) system;
          modules = [
            inputs.home-manager.nixosModules.default
            ./hosts/${host}
            ./users/${username}
          ];
        }
      ) nixosMachines;
      darwinConfigurations = builtins.mapAttrs (
        host: config:
        inputs.darwin.lib.darwinSystem {
          pkgs = pkgsFor config.system;
          inherit (config) system;
          modules = [
            {
              _module.args.user = username;
            }
            {
              nix.enable = false; # https://determinate.systems/posts/nix-darwin-updates/
            }
            (
              { lib, ... }:
              {
                nix.settings.extra-nix-path = lib.mkForce "nixpkgs=${inputs.nixpkgs.outPath}";
              }
            )
            (_: { system.stateVersion = 5; })
            inputs.home-manager.darwinModules.default
            ./hosts/${config.alias}
          ];
        }
      ) darwinMachines;
    };
}
