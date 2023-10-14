HOSTNAME ?=$(shell hostname)
ifndef HOSTNAME
	$(error Hostname unknown)
endif
NIX_REBUILD := sudo nixos-rebuild --flake .\#$(HOSTNAME)

.PHONY: test switch upgrade rollback
test:		; $(NIX_REBUILD) test
switch:		; $(NIX_REBUILD) switch
upgrade:	; $(NIX_REBUILD) upgrade
rollback:	; $(NIX_REBUILD) rollback

.PHONY: update-flake
update-flake: ; nix flake update
#nixos-rebuild switch --flake /path/to/my-flake#my-machine
