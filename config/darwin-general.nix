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
      environment.etc."nix/registry.json".text = builtins.toJSON {
        version = 2;
        flakes = [
          {
            from = {
              type = "indirect";
              id = "nixpkgs";
            };
            to = {
              type = "path";
              path = inputs.nixpkgs.outPath;
              # narHash pins it so `nix flake metadata nixpkgs` doesn't need to reverify
              narHash = inputs.nixpkgs.narHash;
            };
          }
        ];
      };
      nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
      environment.etc."nix/nix.custom.conf".text = ''
        nix-path = "nixpkgs=flake:nixpkgs"
        trusted-users = tirimia
      '';
      fonts.packages = with pkgs; [
        iosevka-comfy.comfy-wide
        intel-one-mono
        fira-code
        source-code-pro
      ];
    };
}
