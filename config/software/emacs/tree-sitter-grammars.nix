{ inputs, ... }:
{
  flake.modules.homeManager.emacs-tree-sitter-grammars =
    { pkgs, lib, ... }:
    let
      libExtension = if pkgs.stdenv.isDarwin then "dylib" else "so";
    in
    {
      home.file.".config/emacs/tree-sitter".source = pkgs.runCommand "grammars" { } ''
        mkdir -p $out
        ${
          lib.concatStringsSep "\n" (
            lib.mapAttrsToList (
              name: src: "name=${name}; ln -s ${src}/parser $out/\lib${name}.${libExtension}"
            ) pkgs.tree-sitter.builtGrammars
          )
        };
      '';
    };
}
