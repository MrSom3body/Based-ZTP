{
  flake.modules.nixos.checkmk-server = {
    imports = [ ./_compose.nix ];
    networking.firewall.allowedTCPPorts = [
      80
      8000
    ];

    services.caddy = {
      enable = true;
      virtualHosts."http://monitoring.infra.nix".extraConfig = ''
        reverse_proxy localhost:8080
      '';
    };
  };
}
