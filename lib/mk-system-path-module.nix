flakeSelf: machinePath:

{ lib, config, ... }:
{
  options.dotfiles = {
    path = lib.mkOption {
      type = lib.types.str;
      description = "The absolute path to the flake on this specific machine.";
    };
    getSystemPath = lib.mkOption {
      type = lib.types.functionTo lib.types.str;
      description = "Resolves a relative flake path to its absolute system path.";
    };
  };

  config.dotfiles = {
    path = machinePath;
    getSystemPath =
      path:
      let
        flakeStorePath = flakeSelf.outPath;
        pathStr = toString path;
        rootLen = builtins.stringLength flakeStorePath;
        isWithinFlake = builtins.substring 0 rootLen pathStr == flakeStorePath;
        relPath = builtins.substring rootLen (builtins.stringLength pathStr - rootLen) pathStr;
      in
      if isWithinFlake then config.dotfiles.path + relPath else pathStr;
  };
}
