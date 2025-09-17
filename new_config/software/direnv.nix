{ inputs, ... }:
{
  flake.modules.homeManager.direnv =
    { pkgs, ... }:
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
