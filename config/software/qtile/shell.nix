{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  nativeBuildInputs = [
    (pkgs.python3.withPackages (import ./qtilePackages.nix))
    pkgs.qtile-unwrapped
  ];
}
