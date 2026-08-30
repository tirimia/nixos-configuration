{ inputs, ... }:
{
  flake.modules.homeManager.emacs-typescript =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bun
        typescript-language-server
        typescript-go
        prettier
        eslint_d
        oxlint
        oxfmt
      ];

      home.file.".config/emacs/init.el".text = builtins.readFile ./config.el;
    };
}
