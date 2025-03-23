{ config, ... }:
{
  home-manager.users.${config.target.user} = {
    home.file.".config/ghc/ghci.conf".text = ''
      :set prompt "\x03BB> "
      :set prompt2 "\x03BB| "
      :set prompt-cont "\x03BB| "
    '';
  };
}
