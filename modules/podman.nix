{
  flake.modules.nixos.podman =
    { pkgs, ... }:
    {
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
    };
}
