{ lib, ... }:
{
  flake.modules.nixos."hosts/omega" = {
    networking = {
      interfaces = {
        "ens160" = {
          useDHCP = false;
          ipv4.addresses = lib.singleton {
            address = "10.40.21.60";
            prefixLength = 24;
          };
        };
        "ens192".useDHCP = true;
        "ens224" = {
          useDHCP = false;
          ipv4.addresses = lib.singleton {
            address = "10.0.1.254";
            prefixLength = 24;
          };
        };
        "ens256" = {
          useDHCP = false;
          ipv4.addresses = lib.singleton {
            address = "10.0.2.254";
            prefixLength = 24;
          };
        };
      };
      nameservers = [ "127.0.0.1" ];
      nat = {
        internalInterfaces = [
          "ens224"
          "ens256"
        ];
        externalInterface = "ens192";
      };

      firewall.allowedTCPPorts = [ 8080 ];
    };
  };
}
