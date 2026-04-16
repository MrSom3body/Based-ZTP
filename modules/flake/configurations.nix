{ lib, config, ... }:
{

  flake.nixosConfigurations =
    let
      mkNixos =
        hostname: extraModules:
        lib.nixosSystem {
          modules = [
            {
              networking.hostName = lib.mkDefault hostname;
              nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
              # This value determines the NixOS release from which the default
              # settings for stateful data, like file locations and database versions
              # on your system were taken. It‘s perfectly fine and recommended to leave
              # this value at the release version of the first install of this system.
              # Before changing this value read the documentation for this option
              # (e.g. man configuration.nix or on https://search.nixos.org/options?&show=system.stateVersion&from=0&size=50&sort=relevance&type=packages&query=stateVersion).
              system.stateVersion = "24.05";
            }
            config.flake.modules.nixos.nixos
            config.flake.modules.nixos."hosts/${hostname}"
          ]
          ++ extraModules;
        };

      commonModules = with config.flake.modules.nixos; [
        amd
        hw-detect
        vmware-guest
      ];

      bigTopoModules =
        commonModules
        ++ (with config.flake.modules.nixos; [
          bt-snmpd
          bt-pki
        ]);

      btClientModules = with config.flake.modules.nixos; [
        desktop
        bt-desktop
      ];
      serverModules = with config.flake.modules.nixos; [ server ];
    in
    {
      ### big topo ###
      all-mgmt = mkNixos "all-mgmt" (bigTopoModules ++ serverModules);
      all-srv-1 = mkNixos "all-srv-1" (
        bigTopoModules ++ serverModules ++ (with config.flake.modules.nixos; [ podman ])
      );

      # clients
      all-ws-1 = mkNixos "all-ws-1" (bigTopoModules ++ btClientModules);
      all-ws-2 = mkNixos "all-ws-2" (bigTopoModules ++ btClientModules);

      ### nwt infra ###
      # server
      lambda = mkNixos "lambda" ((with config.flake.modules.nixos; [ checkmk-server ]) ++ commonModules);
      # router
      omega = mkNixos "omega" ((with config.flake.modules.nixos; [ router ]) ++ commonModules);
      # client
      sigma = mkNixos "sigma" (
        (with config.flake.modules.nixos; [
          desktop
          checkmk-agent
        ])
        ++ commonModules
      );
    };
}
