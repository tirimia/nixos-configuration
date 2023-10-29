{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    fonts.fontconfig.enable = true;
    fonts.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          # "IntoneMono" # TODO: figure out how to get IntelOneMono installed
          "Iosevka"
          "SourceCodePro"
        ];
      })
    ];
  };
}
