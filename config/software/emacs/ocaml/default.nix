{ ... }:
{
  flake.modules.homeManager.emacs-ocaml =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.opam
        pkgs.dune
        pkgs.ocamlPackages.ocaml-lsp
        pkgs.ocamlPackages.ocamlformat
      ];

      home.file.".config/emacs/init.el".text = builtins.readFile ./config.el;
    };
}
