{ lib, ... }:
{
  flake.modules.nixos."hosts/all-mgmt" = {
    networking = {
      defaultGateway = {
        address = "10.1.0.254";
        interface = "ens33";
      };
      interfaces = {
        "ens33" = {
          useDHCP = false;
          ipv4.addresses = lib.singleton {
            address = "10.1.0.100";
            prefixLength = 24;
          };
        };
      };
    };
  };
}
