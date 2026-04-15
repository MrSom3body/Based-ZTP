{ lib, ... }:
{
  flake.modules.nixos."hosts/sigma" = {
    networking = {
      defaultGateway = {
        interface = "ens160";
        address = "10.0.1.254";
      };
      interfaces = {
        "ens160".ipv4.addresses = lib.singleton {
          address = "10.40.21.61";
          prefixLength = 24;
        };
        "ens192".ipv4.addresses = lib.singleton {
          address = "10.0.1.10";
          prefixLength = 24;
        };
      };
    };
  };
}
