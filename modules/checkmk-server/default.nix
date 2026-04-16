{
  flake.modules.nixos.checkmk-server = {
    imports = [ ./_compose.nix ];
    networking.firewall.allowedTCPPorts = [
      80
      8000
    ];

    services.caddy = {
      enable = true;
      virtualHosts."monitoring.infra.nix".extraConfig = ''
        tls internal
        reverse_proxy localhost:8080
      '';
    };
  };
}
