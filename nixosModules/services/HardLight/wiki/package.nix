{
  stdenv,
  mdbook,
  mdbook-admonish,
}:
stdenv.mkDerivation {
  pname = "hardlight-docs";
  version = "d37abb0ac5c1b62095910e7d4024da0292fa12a7";

  src = fetchGit {
    url = "ssh://uriel.squishcat.net:23231/HardLight-Docs.git";
    rev = "d37abb0ac5c1b62095910e7d4024da0292fa12a7";
  };

  nativeBuildInputs = [mdbook mdbook-admonish];

  buildPhase = ''
    runHook preBuild
    mdbook build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -r book/* $out/
    runHook postInstall
  '';
}
