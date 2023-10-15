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
    users.users.${username}.shell = pkgs.zsh;
    home-manager.users.${username} = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        dotDir = ".config/zsh";
        initExtra = ''
          if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-*.zsh" ]]; then
            source "$XDG_CACHE_HOME/p10k-instant-prompt-*.zsh"
          fi
          autoload -Uz promptinit colors
          promptinit
          unsetopt beep
          unsetopt hist_beep
          unsetopt ignore_braces
          unsetopt list_beep
          setopt always_to_end
          setopt prompt_subst
          setopt share_history

              source ~/.config/zsh/powerlevel10k.zsh
        '';
        plugins = [
          {
            name = "cattppuccin-zsh-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "zsh-syntax-highlighting";
              rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
              sha256 = "sha256-Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
            };

            file = "themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";
          }

          {
            name = "nix-zsh-completions";
            src = pkgs.nix-zsh-completions;
            file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
          }

          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }

          {
            name = "zsh-autopair";
            src = pkgs.zsh-autopair;
            file = "share/zsh/zsh-autopair/autopair.zsh";
          }

          {
            name = "zsh-completions";
            src = pkgs.zsh-completions;
            file = "share/zsh-completions/zsh-completions.plugin.zsh";
          }
        ];
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
