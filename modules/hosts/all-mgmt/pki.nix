{
  flake.modules.nixos."hosts/all-mgmt" =
    { pkgs, ... }:
    {
      # Generate internal CA and sign service certificates on first boot.
      # CA key stays on all-mgmt only — service certs are exported read-only via NFS.
      systemd.services.internal-pki = {
        description = "Generate internal CA and service certificates";
        wantedBy = [ "multi-user.target" ];
        before = [ "nfs-server.service" ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        script = ''
          if [ ! -f /var/lib/pki/ca.pem ]; then
            mkdir -p /var/lib/pki/signed

            # Internal CA
            ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 -days 3650 -nodes \
              -keyout /var/lib/pki/ca.key \
              -out    /var/lib/pki/ca.pem \
              -subj "/CN=Verdienstnix Internal CA"
            chmod 600 /var/lib/pki/ca.key

            # Mail server certificate signed by the CA
            ${pkgs.openssl}/bin/openssl req -newkey rsa:4096 -days 3650 -nodes \
              -keyout /var/lib/pki/signed/mail.key \
              -out    /var/lib/pki/signed/mail.csr \
              -subj "/CN=mail.verdienstnix.bundesheer.bigtopo"
            ${pkgs.openssl}/bin/openssl x509 -req \
              -in     /var/lib/pki/signed/mail.csr \
              -CA     /var/lib/pki/ca.pem \
              -CAkey  /var/lib/pki/ca.key \
              -CAcreateserial \
              -out    /var/lib/pki/signed/mail.pem \
              -days   3650
            chmod 600 /var/lib/pki/signed/mail.key
          fi
        '';
      };

      # Export signed certs read-only to all-srv-1 (DMZ host)
      # CA key remains in /var/lib/pki/ and is NOT exported
      services.nfs.server = {
        enable = true;
        exports = ''
          /var/lib/pki/signed  10.1.0.200(ro,no_subtree_check,no_root_squash)
        '';
      };

      networking.firewall.allowedTCPPorts = [ 2049 ];
    };
}
