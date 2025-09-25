{inputs, ...}: {
  flake.modules.homeManager.emacs-haskell = {pkgs, ...}: {
    home.packages = with pkgs; [
      haskell-language-server
      ghc
      fourmolu
      hlint
    ];
    home.file.".config/emacs/init.el".text = ''
      (use-package haskell-mode
        :mode (rx ".hs" eos)
        :config
        (defun tirimia/haskell-setup ()
          "Setup for the maff GOAT."
          (interactive)
          (setq-local eglot-workspace-configuration
                      '(:haskell (:plugin (:stan (:globalOn :json-false)) ; disable stan
                                  :formattingProvider "fourmolu")))
          (eglot-ensure))
        :hook (haskell-mode . tirimia/haskell-setup))
    '';
  };
}
