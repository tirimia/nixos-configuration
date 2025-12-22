{ inputs, ... }:
{
  flake.modules.homeManager.emacs-rust =
    { pkgs, ... }:
    {
      home.packages = [
        (inputs.fenix.packages.${pkgs.system}.combine [
          (inputs.fenix.packages.${pkgs.system}.latest.withComponents [
            "cargo"
            "clippy"
            "rustc"
            "rustfmt"
            "rust-src"
            "rust-analyzer"
          ])
          inputs.fenix.packages.${pkgs.system}.targets.wasm32-unknown-unknown.latest.rust-std
        ])
      ];

      programs.emacs.extraPackages =
        epkgs: with epkgs; [
          rustic
        ];

      home.file.".config/emacs/init.el".text = builtins.readFile ./config.el;
    };
}
