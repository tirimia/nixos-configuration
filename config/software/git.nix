{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [];
  options = {};
  config.home-manager.users.${config.target.user} = {
    programs.git = {
      enable = true;
      userName = "TODO";
      userEmail = "TODO";
      ignores = [
        ".venv"
        ".idea"
      ];
      extraConfig = {
        pull = {
          ff = "only";
        };
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
      };
    };
  };
}
