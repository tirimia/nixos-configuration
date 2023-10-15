{
  pkgs,
  lib,
  config,
  nixpkgs,
  username,
  name,
  email,
  ...
}: {
  imports = [];
  options = {};
  config.home-manager.users.${username} = {
    programs.git = {
      enable = true;
      userName = name;
      userEmail = email;
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
