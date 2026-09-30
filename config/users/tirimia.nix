{ inputs, ... }:
{
  flake.modules.darwin.tirimiaUser =
    let
      name = "tirimia";
    in
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      users.users.tirimia = {
        inherit name;
        home = "/Users/${name}";
      };

      home-manager.users."${name}" = {
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
              github.user = name;
            };
          }
          inputs.self.modules.homeManager.zsh
        ];
        home.stateVersion = "24.05";
      };
    };
}
