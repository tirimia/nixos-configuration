{ ... }:
{
  flake.modules.homeManager.emacs-core =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    {
      programs.emacs = {
        enable = lib.mkDefault true;
        package = lib.mkDefault pkgs.emacs30-pgtk;
      };
      home.packages = with pkgs; [
        ripgrep
        cmake
        glibtool
        just
        just-lsp
        multimarkdown
      ];
      home.file.".config/emacs/init.el".text = lib.mkBefore (builtins.readFile ./config.el);
      home.file.".config/emacs/templateforge".source = config.lib.file.mkOutOfStoreSymlink (
        osConfig.dotfiles.getSystemPath ./templateforge
      );
    };
}
