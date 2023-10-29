{
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}: let
  myEmacs = pkgs.emacs29;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
  myPackages = emacsWithPackages (epkgs: (with epkgs.melpaPackages; [
    vterm
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
        # TODO: add nixd
        packages = with pkgs;
          [
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
            rustc
            rust-analyzer
            ripgrep
            unstablePkgs.bun
            terraform-ls
            yamllint
            unstablePkgs.zig
            unstablePkgs.zls
          ]
          ++ myPackages;
      };
    };
  };
}
