{
  flake.modules.nixos."hosts/omega" =
    { pkgs, ... }:
    let
      domain = "infra.nix";
      omegaIpMgmt = "10.40.21.60";
      omegaIp1 = "10.0.1.254";
      omegaIp2 = "10.0.2.254";
      lambdaIp = "10.0.2.10";
      sigmaIp = "10.0.1.10";
    in
    {
      networking.firewall.allowedUDPPorts = [ 53 ];
      networking.firewall.allowedTCPPorts = [ 53 ];

      services.bind = {
        enable = true;
        forwarders = [
          "9.9.9.9"
          "149.112.112.112"
        ];
        listenOn = [
          "127.0.0.1"
          omegaIpMgmt
          omegaIp1
          omegaIp2
        ];
        listenOnIpv6 = [ "none" ];
        ipv4Only = true;
        cacheNetworks = [
          "10.0.1.0/24"
          "10.0.2.0/24"
          "127.0.0.0/8"
        ];
        extraOptions = ''
          allow-transfer { none; };
          recursion yes;
        '';
        zones = [
          {
            name = domain;
            master = true;
            file = pkgs.writeText "zone-${domain}" ''
              $TTL 86400
              @ IN SOA ns.${domain}. admin.${domain}. (
                  2026041601 ; serial
                  3600       ; refresh
                  1800       ; retry
                  604800     ; expire
                  86400      ; minimum TTL
              )

              @          IN NS  ns.${domain}.

              ns         IN A   ${omegaIp1}
              omega      IN A   ${omegaIp1}
              lambda     IN A   ${lambdaIp}
              sigma      IN A   ${sigmaIp}
              monitoring IN A   ${lambdaIp}
              cloud      IN A   ${lambdaIp}
            '';
          }
        ];
      };
    };
}
