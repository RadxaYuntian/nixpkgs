{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation {
  pname = "gxlimg";
  version = "0-unstable-2024-07-11";

  src = fetchFromGitHub {
    owner = "repk";
    repo = "gxlimg";
    rev = "0d0e5ba9cf396d1338067e8dc37a8bcd2e6874f1";
    sha256 = "sha256-Nt6mTSmFH7ZMiVKGV5T+Wh9DHhJZU1M3UNsclHF5b6w=";
  };

  buildInputs = [
    openssl
  ];

  makeFlags = [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mv gxlimg "$out/bin"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/repk/gxlimg";
    description = "Boot Image creation tool for amlogic s905x (GXL)";
    mainProgram = "gxlimg";
    license = lib.licenses.bsd2;
  };
}
