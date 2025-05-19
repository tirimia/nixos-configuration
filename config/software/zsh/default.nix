{
  pkgs,
  config,
  ...
}:
{
  imports = [ ];
  options = {
  };
  config = {
    programs.zsh.promptInit = '''';
    programs.zsh.enableGlobalCompInit = false;
    programs.zsh.enableBashCompletion = false;
    home-manager.users.${config.target.user} = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        history = {
          save = 1000000;
          size = 1000000;
        };
        dotDir = ".config/zsh";
        shellAliases = {
          cdr = "cd `git rev-parse --show-toplevel`";
          gs = "git status";
          gap = "git add -p";
          gcm = "git commit -m";
          ll = "ls -lathrs";
        };
        initExtra = ''
          if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-*.zsh" ]]; then
             source "$XDG_CACHE_HOME/p10k-instant-prompt-*.zsh"
          fi
          if [[ $(uname) == "Darwin" ]]; then
             source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh # MacOS fix
          fi
          autoload -Uz promptinit colors
          promptinit
          unsetopt beep
          unsetopt hist_beep
          unsetopt ignore_braces
          unsetopt list_beep
          setopt always_to_end
          setopt auto_cd
          setopt prompt_subst
          setopt share_history
          # Make the goddamn delete char work
          bindkey  "^[[3~"   delete-char
          bindkey  "^[3;5~"  delete-char
          bindkey  ";3D"     backward-word
          bindkey  ";3C"     forward-word
          # Emacs vterm
          vterm_printf(){
              if [ -n "$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ] ); then
                  # Tell tmux to pass the escape sequences through
                  printf "\ePtmux;\e\e]%s\007\e\\" "$1"
              elif [ "$${TERM%%-*}" = "screen" ]; then
                  # GNU screen (screen, screen-256color, screen-256color-bce)
                  printf "\eP\e]%s\007\e\\" "$1"
              else
                  printf "\e]%s\e\\" "$1"
              fi
          }
          vterm_cmd() {
              local vterm_elisp
              vterm_elisp=""
              while [ $# -gt 0 ]; do
                  vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
                  shift
              done
              vterm_printf "51;E$vterm_elisp"
          }
          ff() {
              vterm_cmd find-file "''${@:A}"
          }
          nix-sha() {
              nix hash to-sri --type sha256 $(nix-prefetch-url $1)
          }

          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
          eval "$(direnv hook zsh)"
          export CLICOLOR=1 # pretty colors

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

          {
            name = "nix-zsh-completions";
            src = pkgs.nix-zsh-completions;
            file = "share/nix-zsh-completions/nix-zsh-completions.plugin.zsh";
          }
        ];
      };
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      home = {
        packages = with pkgs; [ zsh-powerlevel10k ];
        file.".config/zsh/powerlevel10k.zsh".source = ./powerlevel10k.zsh;
      };
    };
  };
}
