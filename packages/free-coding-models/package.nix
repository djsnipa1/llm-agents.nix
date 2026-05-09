{
  lib,
  flake,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "free-coding-models";
  version = "0.3.55";

  src = fetchFromGitHub {
    owner = "vava-nessa";
    repo = "free-coding-models";
    rev = "v${version}";
    hash = "sha256-gjBJP8GizG/VrcY8XFVUvVilGOV155LbFEt/PcO5/I0=";
  };

  chalk = fetchurl {
    url = "https://registry.npmjs.org/chalk/-/chalk-5.6.2.tgz";
    hash = "sha256-lJV3FaSDqjudtgyPItVJgifYAlxAf5gu74HjTzdXT/0=";
  };

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/free-coding-models
    mkdir -p $out/bin

    cp -r bin src web sources.js patch-openclaw.js patch-openclaw-models.js package.json CHANGELOG.md LICENSE README.md $out/lib/node_modules/free-coding-models/

    mkdir -p $out/lib/node_modules/free-coding-models/node_modules/chalk
    tar -xzf ${chalk} -C $out/lib/node_modules/free-coding-models/node_modules/chalk --strip-components=1

    makeWrapper ${lib.getExe nodejs} $out/bin/free-coding-models \
      --add-flags "$out/lib/node_modules/free-coding-models/bin/free-coding-models.js"

    runHook postInstall
  '';

  dontBuild = true;

  doInstallCheck = false;

  passthru.category = "Utilities";

  meta = {
    description = "Find the fastest coding LLM models in seconds";
    homepage = "https://github.com/vava-nessa/free-coding-models";
    changelog = "https://github.com/vava-nessa/free-coding-models/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with flake.lib.maintainers; [ djsnipa1 ];
    mainProgram = "free-coding-models";
    platforms = lib.platforms.all;
  };
}