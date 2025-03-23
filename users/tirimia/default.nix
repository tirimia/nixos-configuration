{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = "tirimia";
  name = "Theodor Irimia";
  graphicalService = Description: pkg: pkgCommand: {
    Unit = {
      inherit Description;
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkg}/bin/${pkgCommand}";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
in
{
  imports = [
    ../../config/software/zsh
    ../../config/software/git.nix
    ../../config/software/emacs
  ];

  target.user = username;

  users.users.${username} = {
    isNormalUser = true;
    description = name;
    initialPassword = "wouldntyouliketoknowweatherboy";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "docker"
      "tty"
    ];
    shell = pkgs.zsh;
  };
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ username ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      home = {
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
        packages = with pkgs; [
          _1password
          _1password-gui
          thunderbird
        ];
      };
      programs.home-manager.enable = true;
      services.megasync.enable = true;
      systemd.user.services.birdtray =
        graphicalService "Thunderbird system tray" pkgs.birdtray
          "birdtray";
      systemd.user.services._1password =
        graphicalService "1Password system tray" pkgs._1password-gui
          "1password --silent";
    };
  };
}
