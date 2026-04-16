_: {
  # Sets up Caddy as an internal PKI/CA.
  # On first boot Caddy generates the root CA at:
  #   /var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt
  # Use `tls internal` in virtual hosts to get certs signed by this CA.
  # Export the root.crt via NFS so other hosts can mount and trust it.
  flake.modules.nixos.caddy-pki = {
    services.caddy = {
      enable = true;
      globalConfig = ''
        pki {
          ca local {
            name "Infra Internal CA"
          }
        }
      '';
    };

    networking.firewall.allowedTCPPorts = [
      443
      2049
    ];

    services.nfs.server.enable = true;
  };
}
