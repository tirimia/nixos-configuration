{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    fonts.fonts = with pkgs; [
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
