{ lib, ... }:
{
  flake.modules.nixos.nixos =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.git ];

      nix = {
        settings = {
          accept-flake-config = lib.mkForce false;
          log-lines = lib.mkDefault 25; # more log lines

          builders-use-substitutes = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          trusted-users = [
            "root"
            "@wheel"
          ];
        };

        optimise.automatic = !config.boot.isContainer;
      };

      nixpkgs.config.allowUnfree = true;
    };
}
