{ inputs, ... }:
{
  flake.modules.darwin.tirimiaUser =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      users.users.tirimia = {
        name = "tirimia";
        home = "/Users/tirimia";
      };

      home-manager.users.tirimia = {
        imports = [
          inputs.self.modules.homeManager.emacs
          inputs.self.modules.homeManager.neovim
          inputs.self.modules.homeManager.direnv
          inputs.self.modules.homeManager.sre
          inputs.self.modules.homeManager.git
          {
            programs.git.settings = {
              user.name = "Theodor-Alexandru Irimia";
              user.email = "11174371+tirimia@users.noreply.github.com";
              github.user = "tirimia";
            };
          }
          inputs.self.modules.homeManager.zsh
        ];
        home.stateVersion = "24.05";
      };
    };
}
