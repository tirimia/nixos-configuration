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
          "IntoneMono"
          "Iosevka"
          "SourceCodePro"
        ];
      })
    ];
  };
}
