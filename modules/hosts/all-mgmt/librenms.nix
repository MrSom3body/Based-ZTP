{
  flake.modules.nixos."hosts/all-mgmt" =
    { pkgs, ... }:
    {
      services.librenms = {
        enable = true;
        hostname = "all-mgmt.verdienstnix.bundesheer.bigtopo";
        database = {
          createLocally = true;
          socket = "/run/mysqld/mysqld.sock";
        };
        settings = {
          "nets" = [ "10.1.0.0/24" ];
          "discovery_by_ip" = true;
          "snmp.community" = [ "public" ];
          "discovery_modules.discovery-arp" = true;
        };
      };

      environment.systemPackages = [ pkgs.php ];

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    };
}
