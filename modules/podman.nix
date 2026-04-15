{
  flake.modules.nixos.podman =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.podman.composeProjects = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        description = "Compose projects to deploy automatically, keyed by service name.";
        example = lib.literalExpression "{ nextcloud = ./nextcloud/compose.yml; }";
      };

      config = {
        virtualisation = {
          containers.enable = true;

          podman = {
            enable = true;

            dockerCompat = true;
            dockerSocket.enable = true;

            defaultNetwork.settings.dns_enabled = true;
          };
        };

        environment.systemPackages = builtins.attrValues {
          inherit (pkgs)
            podman-compose # start group of containers for dev
            podman-tui # status of containers in the terminal
            ;
        };

        systemd.services = lib.mapAttrs' (
          name: file:
          lib.nameValuePair "podman-compose-${name}" {
            description = "Podman Compose project ${name}";
            wantedBy = [ "multi-user.target" ];
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              WorkingDirectory = toString (builtins.dirOf file);
              ExecStart = "${pkgs.podman-compose}/bin/podman-compose up -d";
              ExecStop = "${pkgs.podman-compose}/bin/podman-compose down";
            };
          }
        ) config.podman.composeProjects;

        systemd.paths = lib.mapAttrs' (
          name: file:
          lib.nameValuePair "podman-compose-${name}" {
            description = "Watch for changes in Compose project ${name}";
            wantedBy = [ "multi-user.target" ];
            pathConfig.PathChanged = toString file;
          }
        ) config.podman.composeProjects;
      };
    };
}
