{
  description = "tirimia NixOS configs";
  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # Import dendritic configuration tree
        (import-tree ./config)
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
}
