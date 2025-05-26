{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ];
  options = { };
  config.home-manager.users.${config.target.user} = {
    programs.git = {
      enable = true;
      userName = "Theodor-Alexandru Irimia";
      userEmail = "11174371+tirimia@users.noreply.github.com";
      ignores = [
        ".venv"
        ".idea"
        ".direnv"
        ".envrc"
      ];
      extraConfig = {
        core = {
          untrackedcache = true;
          fsmonitor = true;
        };
        pull = {
          ff = "only";
          rebase = false;
        };
        rerere.enabled = true; # Reuse conflic resolution

        push = {
          autoSetupRemote = true;
        };
        init = {
          defaultBranch = "main";
        };
        fetch = {
          prune = true;
        };
        status = {
          showUntrackedFiles = "all";
        };
        github = {
          user = "tirimia";
        };
        credential = lib.optionalAttrs pkgs.stdenv.isDarwin {
          helper = "osxkeychain";
        };
      };
      includes = [
        {
          path = "~/work/.gitconfig";
          condition = "gitdir:~/work";
        }
      ];
    };
    home.file."work/.gitconfig".text = ''
      [url "ssh://git@github.com/"]
          insteadOf = https://github.com/
    '';
  };
}
