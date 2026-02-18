{ lib, ... }:
{
  flake.modules.nixos."hosts/omega" = {
    networking = {
      interfaces = {
        "enp1s0".ipv4.addresses = lib.singleton {
          address = "10.0.1.254";
          prefixLength = 24;
        };
        "enp7s0".ipv4.addresses = lib.singleton {
          address = "10.0.2.254";
          prefixLength = 24;
        };
      };
    };
  };
}
