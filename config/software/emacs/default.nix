{
  config,
  lib,
  pkgs,
  ...
}: let
  #vterm-deps = [pkgs.libtool pkgs.cmake pkgs.libvterm-neovim];
  myBaseEmacs = pkgs.emacs-git;
  emacsWithPackages = (pkgs.emacsPackagesFor myBaseEmacs).emacsWithPackages;
  myEmacs = emacsWithPackages (epkgs: (with epkgs; []));
  # TODO: get https://github.com/manateelazycat/holo-layer integrated once pyobjc is in nixpkgs
  myPython = pkgs.python3.withPackages (ppkgs:
    with ppkgs; [
      epc
      sexpdata
      six
      packaging
      python-lsp-server
      ruff-lsp
    ]);
  libExtension =
    if pkgs.system == "aarch64-darwin"
    then "dylib"
    else "so";
  astro-treesit = pkgs.tree-sitter.buildGrammar {
    language = "astro";
    src = pkgs.fetchFromGitHub {
      owner = "virchau13";
      repo = "tree-sitter-astro";
      rev = "4be180759ec13651f72bacee65fa477c64222a1a";
      hash = "sha256-h1QtkJWQm+hgDqEsmnjKyDmNhgTyTkrIAFVg4gUBGXk=";
      leaveDotGit = true;
    };
    version = "latest";
  };
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
              (name: src: "name=${name}; ln -s ${src}/parser $out/\lib${name}.${libExtension}")
              pkgs.tree-sitter.builtGrammars)};
          ln -s ${astro-treesit}/parser $out/libtree-sitter-astro.${libExtension}
        '';
        packages =
          (with pkgs; [
            # TODO: make this a separate derivation for libvterm, see https://weblog.zamazal.org/sw-problem-nixos-emacs-vterm/
            actionlint
            astro-language-server
            black
            bun
            texliveFull # Needed for org pdf export
            docker
            fd
            gleam
            erlang_27
            rebar3
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
            ruff
            ghostscript
            (rust-bin.selectLatestNightlyWith (toolchain:
              toolchain.default.override {
                extensions = ["rust-src" "rust-analyzer"];
              }))
            ripgrep
            bun
            tectonic
            texlab
            watchexec
            terraform-ls
            yamllint
          ])
          ++ [myEmacs myPython]
          #++ vterm-deps
          ;
      };
    };
  };
}
