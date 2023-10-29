{
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}: {
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
      package = pkgs.emacs29;
    };
    home-manager.users.${config.target.user} = {
      home = {
        file.".config/emacs" = {
          source = ./config;
          recursive = true;
        };
        # TODO: add nixd
        packages = with pkgs; [
          black
          cargo
          cmake
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
        ];
      };
    };
  };
}
