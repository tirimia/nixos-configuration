{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    fonts.fontconfig.enable = true;
    fonts.fonts = with pkgs; [
      iosevka-comfy.comfy-wide
      intel-one-mono
      fira-code
      source-code-pro
    ];
  };
}
