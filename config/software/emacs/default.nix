{
  config,
  lib,
  pkgs,
  ...
}:
let
  vterm-deps = [
    pkgs.glibtool
    pkgs.cmake
    pkgs.libvterm-neovim
  ];
  myBaseEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesFor myBaseEmacs).emacsWithPackages;
  myEmacs = emacsWithPackages (epkgs: (with epkgs; [ ]));
  # TODO: get https://github.com/manateelazycat/holo-layer integrated once pyobjc is in nixpkgs
  myPython = pkgs.python3.withPackages (
    ppkgs: with ppkgs; [
      epc
      sexpdata
      six
      packaging
      ruff-lsp
    ]
  );
  libExtension = if pkgs.system == "aarch64-darwin" then "dylib" else "so";
in
{
  imports = [ ];
  options = {
    target.user = lib.mkOption {
      type = lib.types.str;
      description = "User for whom we configure Emacs.";
    };
  };
  config = {
    environment.systemPackages = [ myEmacs ];
    services.emacs = {
      enable = true;
      package = myEmacs;
      additionalPath = [ "/etc/profiles/per-user/${config.target.user}/bin" ];
    };

    home-manager.users.${config.target.user} = {
      home = {
        file.".config/emacs" = {
          source = ./config;
          recursive = true;
        };
        # TODO: try to get the libraries to compile straight into emacs
        file.".config/emacs/tree-sitter".source = pkgs.runCommand "grammars" { } ''
          mkdir -p $out
          ${
            lib.concatStringsSep "\n" (
              lib.mapAttrsToList (
                name: src: "name=${name}; ln -s ${src}/parser $out/\lib${name}.${libExtension}"
              ) pkgs.tree-sitter.builtGrammars
            )
          };
        '';
        packages =
          (with pkgs; [
            # TODO: make this a separate derivation for libvterm, see https://weblog.zamazal.org/sw-problem-nixos-emacs-vterm/
            actionlint
            astro-language-server
            black
            basedpyright
            bun
            texliveFull # Needed for org pdf export
            devenv
            docker
            fd
            gleam
            erlang_27
            rebar3
            elixir
            elixir-ls
            gh
            go
            gofumpt
            golangci-lint
            golangci-lint-langserver
            gopls
            gotools
            lua
            just
            nodejs
            nufmt
            nushell
            carapace # For nu completions
            envsubst # TODO: move this to some separate place
            awscli2
            nodePackages_latest.pnpm
            nodePackages_latest.typescript
            nodePackages_latest.typescript-language-server
            netcat
            ruff
            ghostscript
            (rust-bin.selectLatestNightlyWith (
              toolchain:
              toolchain.default.override {
                extensions = [
                  "rust-src"
                  "rust-analyzer"
                ];
              }
            ))
            ripgrep
            bun
            tectonic
            texlab
            uv
            watchexec
            terraform-ls
            yamllint
            yaml-language-server
          ])
          ++ [ myPython ]
          ++ vterm-deps;
      };
    };
  };
}
