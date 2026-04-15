{
  flake.modules.nixos."hosts/all-srv-1" =
    { lib, ... }:
    {
      networking = {
        nameservers = [ "127.0.0.1" ];
        defaultGateway = {
          address = "10.1.0.252";
          interface = "ens33";
        };
        interfaces = {
          "ens33" = {
            useDHCP = false;
            ipv4.addresses = lib.singleton {
              address = "10.1.0.200";
              prefixLength = 24;
            };
          };
        };

        firewall.allowedTCPPorts = [
          80
          443
          4433
        ];
      };
    };
}
