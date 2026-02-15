{ inputs, ... }:
{
  flake.modules.homeManager.emacs-elixir =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        beamPackages.elixir_1_19
        beamPackages.erlang
        beamPackages.rebar3
        inputs.expert-lsp.packages.${pkgs.system}.default
        beamPackages.elixir-ls
        gleam
      ];
      home.file.".config/emacs/init.el".text = builtins.readFile ./config.el;
    };
}
