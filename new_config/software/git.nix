{ inputs, ... }:
{
  flake.modules.homeManager.git =
    { pkgs, lib, ... }:
    {
      programs.git = {
        enable = true;
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
          rerere.enabled = true; # Reuse conflict resolution

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
          credential = lib.optionalAttrs pkgs.stdenv.isDarwin {
            helper = "osxkeychain";
          };
        };
      };
      home.file."work/.gitconfig".text = ''
        [url "ssh://git@github.com/"]
            insteadOf = https://github.com/
      '';
    };
}
