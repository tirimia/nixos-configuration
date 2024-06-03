{
  config,
  lib,
  pkgs,
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
        # TODO: try to get the libraries to compile straight into emacs
        file.".config/emacs/tree-sitter".source = pkgs.runCommand "grammars" {} ''
          mkdir -p $out
          ${lib.concatStringsSep "\n"
            (lib.mapAttrsToList
              (name: src: "name=${name}; ln -s ${src}/parser $out/\lib${name}${
                if pkgs.system == "aarch64-darwin"
                then ".dylib"
                else ".so"
              }")
              pkgs.tree-sitter.builtGrammars)};
        '';
        packages = with pkgs; [
          myEmacs
          # TODO: make this a separate derivation for libvterm, see https://weblog.zamazal.org/sw-problem-nixos-emacs-vterm/
          cmake
          libvterm-neovim
          actionlint
          black
          bun
          texliveFull # Needed for org pdf export
          docker
          fd
          go
          gofumpt
          golangci-lint
          golangci-lint-langserver
          gopls
          gotools
          lua
          just
          nodejs_18
          envsubst # TODO: move this to some separate place
          awscli2
          nodePackages_latest.pnpm
          nodePackages_latest.typescript
          nodePackages_latest.typescript-language-server
          netcat
          python3
          python311Packages.packaging
          python311Packages.python-lsp-server
          ruff
          python311Packages.ruff-lsp
          (rust-bin.selectLatestNightlyWith (toolchain:
            toolchain.default.override {
              extensions = ["rust-src" "rust-analyzer"];
            }))
          ripgrep
          bun
          terraform-ls
          yamllint
          zig
          zls
        ];
      };
    };
  };
}
