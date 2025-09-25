{ inputs, ... }:
{
  flake.modules.homeManager.emacs-typescript =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        typescript-language-server
        typescript
        nodePackages.prettier
        eslint_d
      ];

      home.file.".config/emacs/init.el".text = builtins.readFile ./config.el;
    };
}
