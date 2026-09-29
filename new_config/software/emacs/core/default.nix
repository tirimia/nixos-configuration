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
        package = lib.mkDefault pkgs.emacs-pgtk;
      };
      home.packages = with pkgs; [
        rassumfrassum # LSP multiplexer
        eask-cli
        ripgrep
        cmake
        glibtool
        just
        just-lsp
        multimarkdown
        # PDF utils
        tectonic
        ghostscript
        tree-sitter # TODO: this was added for neovim
      ];
      home.file.".config/emacs/init.el".text = lib.mkBefore (builtins.readFile ./config.el);
      home.file.".config/emacs/templateforge".source = config.lib.file.mkOutOfStoreSymlink (
        osConfig.dotfiles.getSystemPath ./templateforge
      );
    };
}
