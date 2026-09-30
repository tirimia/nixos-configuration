{ inputs, ... }:
{
  flake.modules.homeManager.emacs-typescript =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bun
        typescript-language-server
        typescript
        prettier
        eslint_d
        oxlint
        oxfmt
      ];

      home.file.".config/emacs/init.el".text = builtins.readFile ./config.el;
    };
}
