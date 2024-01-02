{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  imports = [
    ../../config/software/emacs
    ../../config/software/zsh
  ];
  target.user = user;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;
  system.defaults = {
    dock.autohide = true;
  };
  users.users.${user}.home = "/Users/${user}";
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${user} = {
      home = {
        packages = [pkgs.jq];
        stateVersion = "24.05";
      };
    };
  };
}
/*
  COPY PASTE from https://xyno.space/post/nix-darwin-introduction
  # builds the darwinConfiguration.
# after insalling nix-darwin, we won't need to specify extra-experimental-features anymore
nix build .#darwinConfigurations.YourHostName.system --extra-experimental-features "nix-command flakes"

# the plan is to now run this to install nix-darwin with our configuration
# ./result/sw/bin/darwin-rebuild switch --flake . # this will fail as we first have to do the following lines

printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf # read below
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t # read below

# now we can finally darwin-rebuild
./result/sw/bin/darwin-rebuild switch --flake .  # install nix-darwin
tangent
macOS dosen’t allow any software to write to /. Instead you can write directory names or symlinks to /etc/synthetic.conf.
macOS will then create those files/symlinks on boot. (rebooting is boring, so we’ll just run apfs.util -t to create them immediately)

nix itself has just “nix” inside /etc/synthetic.conf (an empty folder at /nix), it’ll then mount an apfs volume containing your nix store above it.

nix-darwin needs a symlink from /run to /private/var/run to function, that’s whats added in the printf|tee line
*/

