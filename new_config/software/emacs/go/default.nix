{inputs, ...}: {
  flake.modules.homeManager.emacs-go = {pkgs, ...}: {
    home.packages = with pkgs; [
      go
      gopls
      gotools
    ];
    home.file.".config/emacs/init.el".text = builtins.readFile ./config.el;
  };
}
