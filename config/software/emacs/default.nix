{
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}: let
  myBaseEmacs = pkgs.emacs29;
  emacsWithPackages = (pkgs.emacsPackagesFor myBaseEmacs).emacsWithPackages;
  myEmacs = emacsWithPackages (epkgs: (with epkgs.melpaPackages; [
    vterm
  ]));
  treeSitter =
    pkgs.tree-sitter.withPlugins
    (p: [p.tree-sitter-go p.tree-sitter-gomod p.tree-sitter-typescript p.tree-sitter-tsx p.tree-sitter-json]);
in {
  imports = [];
  options = {
    target.user = lib.mkOption {
      type = lib.types.str;
      description = "User for whom we configure Emacs.";
    };
  };
  config = {
    services.emacs = {
      enable = true;
      package = myEmacs;
    };

    home-manager.users.${config.target.user} = {
      home = {
        file.".config/emacs" = {
          source = ./config;
          recursive = true;
        };
        packages = with pkgs; [
          black
          cargo
          docker
          go
          gofumpt
          golangci-lint
          golangci-lint-langserver
          gopls
          gotools
          lua
          just
          unstablePkgs.nixd
          nodePackages_latest.typescript-language-server
          ruff
          rustc
          rust-analyzer
          ripgrep
          unstablePkgs.bun
          terraform-ls
          treeSitter
          yamllint
          unstablePkgs.zig
          unstablePkgs.zls
        ];
      };
    };
  };
}
