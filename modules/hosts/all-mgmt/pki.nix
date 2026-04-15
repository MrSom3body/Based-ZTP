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
          mkdir -p /var/lib/pki/signed

          if [ ! -f /var/lib/pki/ca.pem ]; then
            # Internal CA
            ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 -days 3650 -nodes \
              -keyout /var/lib/pki/ca.key \
              -out    /var/lib/pki/ca.pem \
              -subj "/CN=Verdienstnix Internal CA"
            chmod 600 /var/lib/pki/ca.key
          fi

          if [ ! -f /var/lib/pki/signed/www.pem ]; then
            ${pkgs.openssl}/bin/openssl req -newkey rsa:4096 -days 3650 -nodes \
              -keyout /var/lib/pki/signed/www.key \
              -out    /var/lib/pki/signed/www.csr \
              -subj "/CN=www.verdienstnix.bundesheer.bigtopo"
            ${pkgs.openssl}/bin/openssl x509 -req \
              -in     /var/lib/pki/signed/www.csr \
              -CA     /var/lib/pki/ca.pem \
              -CAkey  /var/lib/pki/ca.key \
              -CAcreateserial \
              -out    /var/lib/pki/signed/www.pem \
              -days   3650 \
              -extfile <(printf "subjectAltName=DNS:www.verdienstnix.bundesheer.bigtopo\nextendedKeyUsage=serverAuth")
            chmod 600 /var/lib/pki/signed/www.key
            cat /var/lib/pki/signed/www.pem /var/lib/pki/ca.pem > /var/lib/pki/signed/www-bundle.pem
          fi

          if [ ! -f /var/lib/pki/signed/mail.pem ]; then
            # Mail server certificate signed by the CA (SAN required by modern TLS clients)
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
              -days   3650 \
              -extfile <(printf "subjectAltName=DNS:mail.verdienstnix.bundesheer.bigtopo\nextendedKeyUsage=serverAuth")
            chmod 600 /var/lib/pki/signed/mail.key
            # Full chain bundle (leaf cert + CA) for Dovecot/Postfix
            cat /var/lib/pki/signed/mail.pem /var/lib/pki/ca.pem > /var/lib/pki/signed/mail-bundle.pem
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
