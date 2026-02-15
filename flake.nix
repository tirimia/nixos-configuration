{
  description = "tirimia NixOS configs";
  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # Enable flake-parts modules support for dendritic pattern
        inputs.flake-parts.flakeModules.modules
        # Import dendritic configuration tree
        (import-tree ./new_config)
      ];
    };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    import-tree.url = "github:vic/import-tree";
    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
    # emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # Other versions are broken
    nix-linter.url = "github:NixOS/nixpkgs/4c3c80df545ec5cb26b5480979c3e3f93518cbe5";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    tree-sitter-astro = {
      url = "github:virchau13/tree-sitter-astro";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    flox.url = "github:flox/flox";
    expert-lsp.url = "github:elixir-lang/expert";
  };
  # outputs =
  #   inputs:
  #   let
  #     nixosMachines = {
  #       stinkpad = {
  #         system = "x86_64-linux";
  #       };
  #     };
  #     darwinMachines = {
  #       trv3692 = {
  #         alias = "emwan";
  #         system = "aarch64-darwin";
  #       };
  #     };
  #     username = "tirimia";
  #     systems = [
  #       "aarch64-darwin"
  #       "x86_64-linux"
  #     ];
  #     pkgsFor =
  #       system:
  #       import inputs.nixpkgs {
  #         overlays = [
  #           # inputs.emacs-overlay.overlays.default
  #           inputs.rust-overlay.overlays.default
  #           inputs.tree-sitter-astro.overlays.default
  #           (final: prev: {
  #             inherit (inputs.nix-linter.legacyPackages.${system}) nix-linter;
  #           })
  #           (final: prev: {
  #             inherit (inputs.flox.packages.${system}) flox;
  #           })
  #           (final: prev: {
  #             kotlin-lsp = final.callPackage ./temporary_recipes/kotlin-lsp.nix { };
  #           })
  #         ];
  #         inherit system;
  #         config.allowUnfree = true;
  #       };
  #   in
  #   {
  #     formatter = inputs.nixpkgs.lib.attrsets.genAttrs systems (
  #       system: (import inputs.nixpkgs { inherit system; }).nixfmt-rfc-style
  #     );
  #     nixosConfigurations = builtins.mapAttrs (
  #       host: config:
  #       inputs.nixpkgs.lib.nixosSystem {
  #         pkgs = pkgsFor config.system;
  #         inherit (config) system;
  #         modules = [
  #           inputs.home-manager.nixosModules.default
  #           ./hosts/${host}
  #           ./users/${username}
  #         ];
  #       }
  #     ) nixosMachines;
  #     darwinConfigurations = builtins.mapAttrs (
  #       host: config:
  #       inputs.darwin.lib.darwinSystem {
  #         pkgs = pkgsFor config.system;
  #         inherit (config) system;
  #         modules = [
  #           {
  #             _module.args.user = username;
  #           }
  #           {
  #             nix.enable = false; # https://determinate.systems/posts/nix-darwin-updates/
  #           }
  #           (
  #             { lib, ... }:
  #             {
  #               nix.settings.extra-nix-path = lib.mkForce "nixpkgs=${inputs.nixpkgs.outPath}";
  #             }
  #           )
  #           (_: { system.stateVersion = 5; })
  #           inputs.home-manager.darwinModules.default
  #           ./hosts/${config.alias}
  #         ];
  #       }
  #     ) darwinMachines;
  #   };
}
