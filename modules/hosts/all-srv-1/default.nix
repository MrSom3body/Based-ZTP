{ lib, pkgs, ... }:
let
  domain = "verdienstnix.big-topo.htl.rennweg.at";
  srvIp = "10.1.0.200";
  mgmtIp = "10.1.0.100";
in
{
  flake.modules.nixos."hosts/all-srv-1" = {
    networking = {
      defaultGateway = {
        address = "10.1.0.254";
        interface = "ens33";
      };
      interfaces = {
        "ens33" = {
          useDHCP = false;
          ipv4.addresses = lib.singleton {
            address = srvIp;
            prefixLength = 24;
          };
        };
      };
    };

    services.bind = {
      enable = true;
      forwarders = [
        "9.9.9.9"
        "149.112.112.112"
      ];
      listenOn = [
        "127.0.0.1"
        srvIp
      ];
      extraOptions = ''
        recursion yes;
        allow-recursion { 10.1.0.0/24; 127.0.0.1; };
        allow-transfer { none; };
      '';
      zones = [
        {
          name = domain;
          master = true;
          file = pkgs.writeText "zone-${domain}" ''
            $TTL 86400
            @ IN SOA ns.${domain}. admin.${domain}. (
                2026010101 ; serial
                3600       ; refresh
                1800       ; retry
                604800     ; expire
                86400      ; minimum TTL
            )

            @         IN NS  ns.${domain}.
            @         IN MX  10 mail.${domain}.

            ns        IN A   ${srvIp}
            @         IN A   ${srvIp}
            mail      IN A   ${srvIp}
            www       IN A   ${srvIp}
            all-srv-1 IN A   ${srvIp}
            all-mgmt  IN A   ${mgmtIp}
          '';
        }
        {
          name = "0.1.10.in-addr.arpa";
          master = true;
          file = pkgs.writeText "zone-reverse" ''
            $TTL 86400
            @ IN SOA ns.${domain}. admin.${domain}. (
                2026010101 ; serial
                3600       ; refresh
                1800       ; retry
                604800     ; expire
                86400      ; minimum TTL
            )

            @ IN NS ns.${domain}.

            200 IN PTR all-srv-1.${domain}.
            100 IN PTR all-mgmt.${domain}.
          '';
        }
      ];
    };
  };
}
