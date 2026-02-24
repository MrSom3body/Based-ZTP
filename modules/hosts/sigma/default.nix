{ lib, ... }:
{
  flake.modules.nixos."hosts/sigma" = {
    networking = {
      defaultGateway = {
        interface = "ens33";
        address = "10.0.1.254";
      };
      interfaces = {
        "ens33".ipv4.addresses = lib.singleton {
          address = "10.0.1.1";
          prefixLength = 24;
        };
      };
    };
  };
}
