# TODO: write zshrc
# TODO: write p10k config somewhere else, not in home
# TODO: install zsh with shit
{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = []; # TODO: maybe import and take advantage of existing zsh module
  options.zsh = {
    for = lib.mkOption {
      type = lib.types.str;
      example = "<username>";
      description = "User for whom we are providing the zsh config.";
    };
  };
  config = {
    home-manager.users.${config.zsh.for}.home = {
      packages = with pkgs; [
        zsh
        zsh-powerlevel10k
      ];
      file.".config/zsh/powerlevel10k.zsh".source = ./powerlevel10k.zsh;
      file.".zshrc".text = ''
        HISTFILE=~/.histfile
        HISTSIZE=1000
        SAVEHIST=1000
        setopt autocd
        bindkey -e
        # End of lines configured by zsh-newuser-install
        # The following lines were added by compinstall
        zstyle :compinstall filename '/home/tirimia/.zshrc'

        autoload -Uz compinit
        compinit
        # End of lines added by compinstall
        source ~/.config/zsh/powerlevel10k.zsh
      '';
    };
  };
}
