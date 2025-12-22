{ inputs, ... }:
{
  flake.modules.darwin.general =
    { pkgs, ... }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      system.stateVersion = 6;
      security.pam.services.sudo_local.touchIdAuth = true;
      system.defaults.dock.autohide = true;
      nix.enable = false; # https://determinate.systems/posts/nix-darwin-updates/
      nix.channel.enable = false;
      fonts.packages = with pkgs; [
        iosevka-comfy.comfy-wide
        intel-one-mono
        fira-code
        source-code-pro
      ];
    };
}
