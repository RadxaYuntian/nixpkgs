{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:

buildGhidraExtension (finalAttrs: {
  pname = "ghidra-mcp";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "bethington";
    repo = "ghidra-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LnhhJwycO8NQV+YaTP7ZoxGkoGLkc14BwY66wczbpp0=";
  };

  # Offline unit tests pull JUnit/Mockito from Maven Central; skip them.
  # Integration coverage needs a live Ghidra instance.
  dontUseGradleCheck = true;

  # Custom Gradle task writes the extension zip to build/distributions/
  # rather than the dist/ directory that Ghidra's ExtensionModule plugin uses.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/ghidra/Ghidra/Extensions
    unzip -d $out/lib/ghidra/Ghidra/Extensions build/distributions/*.zip

    # Prevent attempted creation of plugin lock files in the Nix store.
    for i in $out/lib/ghidra/Ghidra/Extensions/*; do
      touch "$i/.dbDirLock"
    done

    runHook postInstall
  '';

  meta = {
    description = "Ghidra extension that exposes reverse-engineering tools over HTTP for MCP clients";
    homepage = "https://github.com/bethington/ghidra-mcp";
    downloadPage = "https://github.com/bethington/ghidra-mcp/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/bethington/ghidra-mcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.RadxaYuntian ];
  };
})
