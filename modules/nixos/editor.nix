{
  flake.modules.nixos.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.helix
        pkgs.neovim
      ];
    };
}
