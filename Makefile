HOSTNAME ?=$(shell hostname)
ifndef HOSTNAME
	$(error Hostname unknown)
endif
NIX_REBUILD := sudo nixos-rebuild --flake .\#$(HOSTNAME)

.PHONY: mac-switch
mac-switch: ; sudo darwin-rebuild switch --flake .
show-emacs: ; nix eval .#darwinConfigurations.emwan.config.home-manager.users.tirimia.programs.emacs.extraConfig --raw
build-home: ; nix build '.#darwinConfigurations.emwan.config.home-manager.users.tirimia.home.activationPackage'
.PHONY: test switch upgrade rollback
test:		; $(NIX_REBUILD) test
switch:		; $(NIX_REBUILD) switch # Take name as argument, worst case timestamp - ooor, format name of last commit if on clean tree
upgrade:	; $(NIX_REBUILD) upgrade
rollback:	; $(NIX_REBUILD) rollback

.PHONY: update-flake
update-flake: ; nix flake update
#nixos-rebuild switch --flake /path/to/my-flake#my-machine
#nix build .#darwinConfigurations.Theodor-Irimia-s-MacBook-Pro.system --extra-experimental-features "nix-command flakes"
