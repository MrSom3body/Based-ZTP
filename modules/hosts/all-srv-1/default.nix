{ lib, ... }:
{
  flake.modules.nixos."hosts/all-srv-1" = {
    networking = {
      defaultGateway = {
        address = "10.1.0.254";
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
    };
  };
}
