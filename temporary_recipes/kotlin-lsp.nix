{
  lib,
  stdenv,
  fetchzip,
  openjdk,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "0.253.10629";
  src = fetchzip {
    stripRoot = false;
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-${version}.zip";
    hash = "sha256-LCLGo3Q8/4TYI7z50UdXAbtPNgzFYtmUY/kzo2JCln0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mkdir -p $out/native
    mkdir -p $out/bin
    cp -r lib/* $out/lib
    cp -r native/* $out/native
    chmod +x kotlin-lsp.sh
    cp "kotlin-lsp.sh" "$out/kotlin-lsp.sh"
    ln -s $out/kotlin-lsp.sh $out/bin/kotlin-lsp

    runHook postInstall
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  postFixup = ''
    wrapProgram "$out/bin/kotlin-lsp" --set JAVA_HOME ${openjdk} --prefix PATH : ${
      lib.strings.makeBinPath [
        openjdk
      ]
    }
  '';
}
