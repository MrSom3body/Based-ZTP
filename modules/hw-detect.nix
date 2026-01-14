{
  flake.modules.nixos.hw-detect =
    { modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
    };
}
