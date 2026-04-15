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
        package = pkgs.stable.bind;
        forwarders = [
          "172.16.7.1"
          "9.9.9.9"
          "149.112.112.112"
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
          recursion yes;
        '';
        extraConfig = ''
          zone "bundesheer.bigtopo" {
            type forward;
            forwarders { 172.16.7.1; };
          };
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
                "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj8JuC3F1fyrOqUF+wHOjFVo13knhNT4JiszW0Cls1hLT5H1m0t7m3LUsW9ApD7CvZ926Fd6DoFiCEj6wNyz6045FT83sDGe4oTMtANeZrxsAm3j36yrph3Tp2bIAXzejq2Bdu1ZfmcURqIFcFxxd7y76XiPQqYuceRR/5gi8XCLFzQFGVNfylpf9nMWGVZivTwGnepxexfGNZqCJE"
                "O6GlAFWxDraXc63N8cZaYsueBkomRDmLoOdoovlY4Juq3UQf8M5iaGSylGiwQXBoDtPjoIYqww7bI64+YsD8I5YZ1OXgShYiGaR1QtUbv1FYmjcmWIOCcWuUGE08WuAFlFZRwIDAQAB"
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
