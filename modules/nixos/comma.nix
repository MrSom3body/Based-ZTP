{ inputs, ... }:
{
  flake.modules.nixos.nixos = {
    imports = [ inputs.nix-index-database.nixosModules.nix-index ];
    programs.nix-index-database.comma.enable = true;
  };
}
