{
  pkgs,
  lib,
  config,
  username,
  ...
}: {
  imports = []; # TODO: maybe import and take advantage of existing zsh module
  options = {};
  config = {
    home-manager.users.${username} = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        dotDir = ".config/zsh";
        initExtra = ''
          source ~/.config/zsh/powerlevel10k.zsh
        '';
      };
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      home = {
        file.".config/zsh/powerlevel10k.zsh".source = ./powerlevel10k.zsh;
      };
    };
  };
}
