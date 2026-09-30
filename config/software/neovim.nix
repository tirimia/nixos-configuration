{ inputs, ... }:
{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.neovide
        pkgs.neovim
      ];
    };
}
