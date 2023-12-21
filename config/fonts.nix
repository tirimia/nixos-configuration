{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    fonts.fontconfig.enable = true;
    fonts.packages = with pkgs; [
      iosevka-comfy.comfy-wide
      intel-one-mono
      fira-code
      source-code-pro
    ];
  };
}
