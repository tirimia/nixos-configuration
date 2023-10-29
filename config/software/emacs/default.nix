{
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}: let
  myBaseEmacs = pkgs.emacs29;
  emacsWithPackages = (pkgs.emacsPackagesFor myBaseEmacs).emacsWithPackages;
  myEmacs = emacsWithPackages (epkgs: (with epkgs; [
    melpaPackages.vterm
  ]));
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
        file.".tree-sitter".source = pkgs.runCommand "grammars" {} ''
          mkdir -p $out/bin
          ${lib.concatStringsSep "\n"
            (lib.mapAttrsToList
              (name: src: "name=${name}; ln -s ${src}/parser $out/bin/\${name#tree-sitter-}.so")
              pkgs.tree-sitter.builtGrammars)};
        '';
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
          nodePackages_latest.typescript-language-server
          ruff
          rustc
          rust-analyzer
          ripgrep
          unstablePkgs.bun
          terraform-ls
          yamllint
          unstablePkgs.zig
          unstablePkgs.zls
        ];
      };
    };
  };
}
