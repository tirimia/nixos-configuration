{
  pkgs,
  lib,
  config,
  nixpkgs,
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
        oh-my-zsh = {
          enable = true;
          custom = ".config/zsh/oh-my-zsh";
          theme = "powerlevel10k";
          plugins =
            [
              "sudo"
              "git"
              "fzf"
            ]
            ++ lib.optionals pkgs.stdenv.isDarwin ["brew" "macos"]
            ++ lib.optionals pkgs.stdenv.isLinux [];
        };
        initExtra = ''
          source ~/.config/zsh/powerlevel10k.zsh
        '';
      };
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      home = {
        packages = [pkgs.zsh-powerlevel10k];
        file.".config/zsh/powerlevel10k.zsh".source = ./powerlevel10k.zsh;
      };
    };
  };
}
