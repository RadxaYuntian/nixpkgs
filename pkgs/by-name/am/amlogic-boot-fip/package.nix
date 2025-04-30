{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "amlogic-boot-fip";
  version = "0-unstable-2024-09-20";

  src = fetchFromGitHub {
    owner = "LibreELEC";
    repo = "amlogic-boot-fip";
    rev = "8599bc77b17f38e69275f6145acc5792faab735e";
    sha256 = "sha256-Kp36lxFglmgUW4CpUQ0bnjBpPOC/BQ74a5T0FPW+0DU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -ar . "$out/bin"

    runHook postInstall
  '';

  postFixup = ''
    patchShebangs --build $out/
  '';

  meta = {
    homepage = "https://github.com/LibreELEC/amlogic-boot-fip";
    description = "Firmware Image Pacakge (FIP) sources used to sign Amlogic u-boot binaries in LibreELEC images";
    license = lib.licenses.unfreeRedistributableFirmware;
  };
}
