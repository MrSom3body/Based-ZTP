{ lib, ... }:
{
  flake.modules.nixos."hosts/omega" = {
    networking = {
      interfaces = {
        "ens33".useDHCP = true;
        "ens36" = {
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
      nat = {
        internalInterfaces = [
          "ens36"
          "ens37"
        ];
        externalInterface = "ens33";
      };
    };
  };
}
