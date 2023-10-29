{
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}: let
  myEmacs = pkgs.emacs29;
  # This generates an emacsWithPackages function. It takes a single
  # argument: a function from a package set to a list of packages
  # (the packages that will be available in Emacs).
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
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
          ++ emacsWithPackages (epkgs: (with epkgs.melpaPackages; [
            vterm
          ]));
      };
    };
  };
}
