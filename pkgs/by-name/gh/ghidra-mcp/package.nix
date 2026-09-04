{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ghidra-mcp";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bethington";
    repo = "ghidra-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LnhhJwycO8NQV+YaTP7ZoxGkoGLkc14BwY66wczbpp0=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    mcp
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pyyaml
    requests
  ];

  pythonImportsCheck = [ "bridge_mcp_ghidra" ];

  pytestFlags = [ "tests/unit" ];

  disabledTestPaths = [
    # Exercise the unshipped tools.setup / Gradle / debugger subsystems.
    "tests/unit/test_debugger_engine.py"
    "tests/unit/test_debugger_server.py"
    "tests/unit/test_gradle_tasks.py"
    "tests/unit/test_setup_cli.py"
    "tests/unit/test_setup_ghidra.py"
    "tests/unit/test_setup_ghidra_process_detection.py"
    "tests/unit/test_setup_requirements.py"
    "tests/unit/test_windbg.py"
    # Inspect repo-level versioning / project layout, not the installed wheel.
    "tests/unit/test_d2_conventions.py"
    "tests/unit/test_project_consistency.py"
    "tests/unit/test_version_bump.py"
    "tests/unit/test_versioning.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP bridge exposing Ghidra reverse-engineering tools to AI clients";
    longDescription = ''
      Python MCP server (`bridge-mcp-ghidra`) that multiplexes Model Context
      Protocol requests to a running GhidraMCP HTTP plugin.

      The matching Ghidra extension is available as
      `ghidra-extensions.ghidra-mcp` and can be loaded with:

          ghidra.withExtensions (p: [ p.ghidra-mcp ])
    '';
    homepage = "https://github.com/bethington/ghidra-mcp";
    downloadPage = "https://github.com/bethington/ghidra-mcp/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/bethington/ghidra-mcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.RadxaYuntian ];
    mainProgram = "bridge-mcp-ghidra";
  };
})
