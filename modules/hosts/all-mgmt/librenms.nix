{
  flake.modules.nixos."hosts/all-mgmt" = {
    services.librenms = {
      enable = true;
      hostname = "all-mgmt.verdienstnix.bundesheer.bigtopo";
      database = {
        createLocally = true;
        socket = "/run/mysqld/mysqld.sock";
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
