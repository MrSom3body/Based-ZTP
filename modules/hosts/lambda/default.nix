{ lib, ... }:
{
  flake.modules.nixos."hosts/lambda" = {
    networking = {
      defaultGateway = {
        interface = "ens33";
        address = "10.0.2.254";
      };
      interfaces = {
        "ens33".ipv4.addresses = lib.singleton {
          address = "10.0.2.10";
          prefixLength = 24;
        };
      };
    };
  };
}
