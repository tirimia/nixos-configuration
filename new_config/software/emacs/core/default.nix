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
            aas
          ];
        extraConfig = lib.mkBefore (builtins.readFile ./config.el);
      };
    };
}
