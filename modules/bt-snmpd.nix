{
  flake.modules.nixos.bt-snmpd =
    { pkgs, ... }:
    {
      services.snmpd = {
        enable = true;
        configFile = pkgs.writeText "snmpd.conf" ''
          rocommunity public 10.1.0.0/24
          syslocation Allensteig
          syscontact admin@verdienstnix.bundesheer.bigtopo
        '';
      };

      networking.firewall.allowedUDPPorts = [ 161 ];
    };
}
