{
  pkgs,
  lib,
}:
pkgs.buildNpmPackage (finalAttrs: {
  pname = "sillytavern";
  version = "1.18.0";

  src = pkgs.fetchFromGitHub {
    owner = "SillyTavern";
    repo = "SillyTavern";
    tag = finalAttrs.version;
    hash = "sha256-1FDqbV+t9JF93aTgy7Hnwe4lCJZHooHw0J3zOsCZWDA=";
  };
  npmDepsHash = "sha256-jDySPn354gh1gFI8I2apGmXDxOz4d4STfJX+iFVFhdg=";

  nodejs = pkgs.nodejs_22;

  nativeBuildInputs = [pkgs.makeBinaryWrapper];

  dontNpmBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt}
    cp -r . $out/opt/sillytavern
    makeWrapper ${lib.getExe pkgs.nodejs} $out/bin/sillytavern \
      --add-flags $out/opt/sillytavern/server.js \
      --set-default NODE_ENV production

    runHook postInstall
  '';

  meta = {
    description = "LLM Frontend for Power Users";
    longDescription = ''
      SillyTavern is a user interface you can install on your computer (and Android phones) that allows you to interact with
      text generation AIs and chat/roleplay with characters you or the community create.
    '';
    downloadPage = "https://github.com/SillyTavern/SillyTavern/releases";
    homepage = "https://docs.sillytavern.app/";
    mainProgram = "sillytavern";
    license = lib.licenses.agpl3Only;
    maintainers = [lib.maintainers.Notarin];
  };
})
