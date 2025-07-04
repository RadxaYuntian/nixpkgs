{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  dpkg,
  glib,
  nss,
  nspr,
  dbus,
  atk,
  cups,
  libdrm,
  gtk3,
  pango,
  cairo,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libgbm,
  expat,
  libxcb,
  libxkbcommon,
  alsa-lib,
  libglvnd,
  icu,
  libidn2,
  rtmpdump,
  cyrus_sasl,
  vivaldi-ffmpeg-codecs,
  gnutls,
  libkrb5,
  sqlite,
  libxcrypt,
}:
let
  version = system: {
    aarch64-linux = "1.13.4";
    x86_64-linux = "1.16.0";
  }.${system};

  src = system: {
    aarch64-linux = fetchurl {
      url = "https://softwarecenter.qualcomm.com/api/download/software/tools/Qualcomm_Software_Center/Linux/ARM64/Debian/${version system}/QualcommSoftwareCenter${version system}.Linux-arm64.deb";
      hash = "sha256-9uHmGodawLUhDe8/dn8NVaXKuMsEPG+DIRJXc3KSFu8=";
    };
    x86_64-linux = fetchurl {
      url = "https://softwarecenter.qualcomm.com/api/download/software/tools/Qualcomm_Software_Center/Linux/Debian/${version system}/QualcommSoftwareCenter${version system}.Linux-x86.deb";
      hash = "sha256-H+tGR4BnIJC+vI2X4j1RNWXqqsg5IKC4KjAwxWkk5yY=";
    };
  }.${system};

  buildInputs = [
    glib
    nss
    nspr
    dbus
    atk
    cups
    libdrm
    gtk3
    pango
    cairo
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libgbm
    expat
    libxcb
    libxkbcommon
    alsa-lib
    libglvnd
    icu
    libidn2
    rtmpdump
    cyrus_sasl
    vivaldi-ffmpeg-codecs
    gnutls
    libkrb5
    sqlite
    libxcrypt
  ];
in
stdenvNoCC.mkDerivation {
  pname = "QualcommSoftwareCenter";
  version = version stdenvNoCC.hostPlatform.system;

  src = src stdenvNoCC.hostPlatform.system;

  nativeBuildInputs = [
    makeWrapper
    dpkg
    autoPatchelfHook
  ];

  buildInputs = buildInputs;

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp -R usr/* opt $out/
    cp -R tmp/qcom/qsc_installer/external-dependencies/libs/system-deps $out/lib
    cp tmp/qcom/qsc_installer/external-dependencies/libs/openssl3.0.0/* $out/lib

    runHook postInstall
  '';

  dontAutoPatchelf = true;

  fixupPhase = ''
    runHook preFixup

    for i in softwarecenter qik/qik qpm-cli/qpm-cli qsc-cli/qsc-cli; do
      ln -s $out/opt/qcom/softwarecenter/bin/$i $out/bin/$(basename $i)

      wrapProgram $out/opt/qcom/softwarecenter/bin/$i \
        --prefix LD_LIBRARY_PATH : $out/lib:$out/opt/qcom/softwarecenter/bin:$out/opt/qcom/softwarecenter/bin/$(basename $i):${
          lib.makeLibraryPath buildInputs
        }
    done

    substituteInPlace $out/share/applications/qualcommsoftwarecenter.desktop \
      --replace-fail "Exec=/opt/qcom/softwarecenter" "Exec=$out"

    runHook postFixup
  '';

  meta = {
    homepage = "https://softwarecenter.qualcomm.com/catalog/item/Qualcomm_Software_Center";
    description = "Qualcomm® Software Center manages Qualcomm® software and simplifies the development process";
    mainProgram = "softwarecenter";
    sourceProvenance = [
      lib.sourceTypes.binaryNativeCode
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.unfree;
  };
}
