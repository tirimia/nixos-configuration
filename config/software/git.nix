{ ... }:
{
  flake.modules.homeManager.git =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.jujutsu ];
      home.file.".config/jj/config.toml".text = ''
        [user]
        name = "Theodor-Alexandru Irimia"
        email = "11174371+tirimia@users.noreply.github.com"
      '';
      programs.git = {
        enable = true;
        ignores = [
          ".venv"
          ".idea"
          ".direnv"
          ".envrc"
          ".DS_Store"
          ".dir-locals.el"
        ];
        settings = {
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
          credential = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
            helper = "osxkeychain";
          };
        };
      };
      home.file."git/github.com/trivago/.gitconfig".text = ''
        [url "ssh://git@github.com/"]
            insteadOf = https://github.com/
      '';
    };
}
