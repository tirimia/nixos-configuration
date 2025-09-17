# { inputs, ... }:
# {
#   flake.modules.homeManager.nix-linter =
#     { pkgs, ... }:
#     {
#       home.packages = [ inputs.nix-linter.legacyPackages.${pkgs.system}.nix-linter ];
#     };
# }
{ inputs, ... }:
let
  flake.modules.darwin = { inherit nix-settings; };
  flake.modules.nixos = { inherit nix-settings; };
  nix-settings =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nixfmt-tree
        inputs.nix-linter.legacyPackages.${pkgs.system}.nix-linter
        nixd
      ];
    };
in
{
  inherit flake;
}
