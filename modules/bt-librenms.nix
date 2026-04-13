{
  flake.modules.nixos.bt-librenms = {
    services.librenms = {
      enable = true;
      hostname = "all-mgmt.verdienstnix.big-topo.htl.rennweg.at";
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
