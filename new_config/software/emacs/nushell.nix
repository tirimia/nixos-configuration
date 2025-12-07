{ inputs, ... }:
{
  flake.modules.homeManager.emacs-nushell =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nushell
      ];

      programs.emacs.extraPackages =
        epkgs: with epkgs; [
          nushell-ts-mode
        ];
      home.file.".config/emacs/init.el".text = ''
        (use-package nushell-ts-mode
          :config
          (defun tirimia/nushell-setup ()
            "Time for the nu shizz."
            (interactive)
            (eglot-ensure))
          :hook (nushell-ts-mode . tirimia/nushell-setup))
      '';
    };
}
