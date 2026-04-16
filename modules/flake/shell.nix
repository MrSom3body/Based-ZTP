{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = builtins.attrValues {
          inherit (pkgs)
            compose2nix
            git
            just
            nixos-anywhere
            ;
        };

        buildInputs = [ ];

        shellHook = ''
          ${config.pre-commit.settings.shellHook}
        '';
      };
    };
}
