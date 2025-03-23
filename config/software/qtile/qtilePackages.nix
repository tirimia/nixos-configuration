python3Packages: with python3Packages; [
  xlib
  # https://github.com/NixOS/nixpkgs/issues/271610#issuecomment-1837247382
  (qtile-extras.overridePythonAttrs (_: {
    disabledTestPaths = [ "test/widget/test_strava.py" ];
  }))
  pulsectl-asyncio # For PulseVolume
  psutil # For CPU and Memory
]
