{ inputs, ... }:
{
  flake.modules.homeManager.emacs-core =
    { pkgs, lib, ... }:
    {
      programs.emacs = {
        enable = lib.mkDefault true;
        package = lib.mkDefault pkgs.emacs30-pgtk;
        extraPackages =
          epkgs: with epkgs; [
            use-package
            eglot
            yasnippet
            evil
            evil-textobj-tree-sitter
            telephone-line
            org-contacts
            tree-sitter tree-sitter-langs treesit-grammars.with-all-grammars
          ];
      };
      home.file.".config/emacs/init.el".text = lib.mkBefore (builtins.readFile ./config.el);
    };
}
