{
  flake.modules.nixos."hosts/all-srv-1" =
    { pkgs, ... }:
    let
      domain = "verdienstnix.bundesheer.bigtopo";
      srvIp = "10.1.0.200";
      mgmtIp = "10.1.0.100";
    in
    {
      networking.firewall.allowedUDPPorts = [ 53 ];

      services.bind = {
        enable = true;
        forwarders = [
          # "9.9.9.9"
          # "149.112.112.112"
        ];
        listenOn = [
          "127.0.0.1"
          srvIp
        ];
        listenOnIpv6 = [ "none" ];
        ipv4Only = true;
        cacheNetworks = [
          "10.1.0.0/16"
          "127.0.0.0/8"
          "::1/128"
        ];
        extraOptions = ''
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

              @      IN TXT "v=spf1 mx -all"
              _dmarc IN TXT "v=DMARC1; p=none;"
              ; DKIM: after first deploy, copy from /var/dkim/*.mail.txt
              ; mail._domainkey IN TXT "v=DKIM1; k=rsa; p=..."
              mail._domainkey IN TXT ( "v=DKIM1; k=rsa; "
                "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmcwNbgS2BCVgbLEUGW75p8YdDBmivSSbz1XPKFuWmq8cJZ1UDtokMYKdQGi/utRqkmkk/BJltsAtGsBY3bZmcc4bTyweu++SkaBs/SzW2dYz+NM6BlMcTQdxdCwZBRuPiTjGexLj6jEzVd6/741rZYVF1JvyPDJGKJKZFy1rSGNGB1z08dHc5QTyzgElIDVYDyUs3bE5ujZfkHtVy"
                "AJYj55pQfIyYKt7n+1Ps2u4xmMd9zHlzHMYClSPxhHulpNHDq7vrStzwiVpQCgPHPD+b9SFpK9iIpfXFQl7D8n/ZapFhTKiA9mZZqUXLgHRf/4Vohvdwa96JgpGDxX5FPrGkwIDAQAB"
              ) ;
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
