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
          "IntelOneMono"
          "Iosevka"
          "SourceCodePro"
        ];
      })
    ];
  };
}
