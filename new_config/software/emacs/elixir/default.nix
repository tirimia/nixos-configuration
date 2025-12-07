{ inputs, ... }:
{
  flake.modules.homeManager.emacs-elixir =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        erlang_27
        rebar3
        elixir
        elixir-ls
        gleam
      ];
      # TODO: add expert flake and install expert as the lsp
      home.file.".config/emacs/init.el".text = builtins.readFile ./config.el;
      #home.file.".config/emacs/snippets/elixir-mode".source = ./snippets;
    };
}
