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

      programs.emacs.extraConfig = builtins.readFile ./config.el;
    };
}
