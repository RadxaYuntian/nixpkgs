{
  lib,
  stdenv,
  fetchFromGitHub,
  python2,
  python3,
}:

stdenv.mkDerivation {
  pname = "meson64-tools";
  version = "0-unstable-2023-07-25";

  src = fetchFromGitHub {
    owner = "angerman";
    repo = "meson64-tools";
    rev = "b09cefd1e001dbba14036857bf6e167bf1833f26";
    sha256 = "sha256-/koIsslDNpaFHf1TV/0Xt0TiyhjL6tCz2oHQraYNhPA=";
  };

  nativeBuildInputs = [
    python2
    python3
  ];

  prePatch = ''
    patchShebangs ./mbedtls/scripts/
  '';

  makeFlags = [
    "all"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mv bootmk bl2sig bl3sig bl30sig pkg "$out/bin"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/angerman/meson64-tools";
    description = "The Amlogic S922X boot";
    license = lib.licenses.mit;
  };
}
