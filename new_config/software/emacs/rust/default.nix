{ inputs, ... }:
{
  flake.modules.homeManager.emacs-rust =
    { pkgs, lib, ... }:
    {
      home.packages = [
        (inputs.fenix.packages.${pkgs.system}.latest.withComponents [
          "cargo"
          "clippy"
          "rustc"
          "rustfmt"
          "rust-src"
          "rust-analyzer"
        ])
      ];

      programs.emacs.extraPackages =
        epkgs: with epkgs; [
          rustic
        ];

      programs.emacs.extraConfig = lib.mkAfter (builtins.readFile ./config.el);
    };
}
