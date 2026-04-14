{ self, ... }:
{
  flake.modules.nixos.nixos = {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = builtins.attrValues self.overlays;
    };
  };
}
