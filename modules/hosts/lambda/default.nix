{ lib, ... }:
{
  flake.modules.nixos."hosts/lambda" = {
    networking = {
      defaultGateway = {
        interface = "ens192";
        address = "10.0.2.254";
      };
      interfaces = {
        "ens160".ipv4.addresses = lib.singleton {
          address = "10.40.21.62";
          prefixLength = 24;
        };
        "ens192".ipv4.addresses = lib.singleton {
          address = "10.0.2.10";
          prefixLength = 24;
        };
      };
    };
  };
}
