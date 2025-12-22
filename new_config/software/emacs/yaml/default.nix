{ inputs, ... }:
{
  flake.modules.homeManager.emacs-yaml =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        yaml-language-server
      ];
      programs.emacs.extraPackages =
        epkgs: with epkgs; [
          k8s-mode
        ];
      home.file.".config/emacs/init.el".text = builtins.readFile ./config.el;
    };
}
