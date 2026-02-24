{ lib, ... }:
{
  flake.modules.nixos."hosts/omega" = {
    networking = {
      defaultGateway = {
        interface = "ens33";
        address = "10.0.1.2";
      };
      interfaces = {
        "ens33" = {
          useDHCP = false;
          ipv4.addresses = lib.singleton {
            address = "10.0.1.254";
            prefixLength = 24;
          };
        };
        "ens37" = {
          useDHCP = false;
          ipv4.addresses = lib.singleton {
            address = "10.0.2.254";
            prefixLength = 24;
          };
        };
      };
    };
  };
}
