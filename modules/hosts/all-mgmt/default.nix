{
  flake.modules.nixos."hosts/all-mgmt" =
    { lib, ... }:
    let
      srvIp = "10.1.0.200";
    in
    {
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
        nameservers = [ srvIp ];
      };

      services.kea.dhcp4 = {
        enable = true;
        settings = {
          interfaces-config.interfaces = [ "ens33" ];
          lease-database = {
            type = "memfile";
            persist = true;
            name = "/var/lib/kea/dhcp4.leases";
          };
          subnet4 = lib.singleton {
            id = 1;
            subnet = "10.1.0.0/24";
            pools = lib.singleton { pool = "10.1.0.1 - 10.1.0.99"; };
            option-data = [
              {
                name = "routers";
                data = "10.1.0.254";
              }
              {
                name = "domain-name-servers";
                data = "${srvIp}";
              }
            ];
            valid-lifetime = 86400;
          };
        };
      };
    };
}
