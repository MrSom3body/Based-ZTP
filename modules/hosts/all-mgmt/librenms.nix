{
  flake.modules.nixos."hosts/all-mgmt" = {
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
        "discovery_modules.arp-table" = true;
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
