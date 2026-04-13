{ inputs, ... }:
{
  flake.modules.nixos."hosts/all-srv-1" =
    { pkgs, ... }:
    {
      imports = [ inputs.simple-nixos-mailserver.nixosModules.mailserver ];

      # Generate self-signed certificate for internal mail server
      systemd.services.mail-selfsigned-cert = {
        description = "Generate self-signed certificate for mailserver";
        before = [
          "postfix.service"
          "dovecot2.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        script = ''
          if [ ! -f /var/lib/mailserver/cert.pem ]; then
            mkdir -p /var/lib/mailserver
            ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 \
              -keyout /var/lib/mailserver/key.pem \
              -out /var/lib/mailserver/cert.pem \
              -days 3650 -nodes \
              -subj "/CN=mail.verdienstnix.bundesheer.bigtopo"
            chmod 640 /var/lib/mailserver/key.pem
          fi
        '';
      };

      mailserver = {
        enable = true;
        stateVersion = 4;
        fqdn = "mail.verdienstnix.bundesheer.bigtopo";
        domains = [ "verdienstnix.bundesheer.bigtopo" ];

        x509.certificateFile = "/var/lib/mailserver/cert.pem";
        x509.privateKeyFile = "/var/lib/mailserver/key.pem";
        localDnsResolver = false;

        accounts = {
          "admin@verdienstnix.bundesheer.bigtopo" = {
            # generate with: mkpasswd -m bcrypt
            hashedPassword = "$2b$05$lQlmTe9Ilo/gPCcaMagN2eeYQfjw0WV2VAPJiBQ6QCbWL9obJ0inK";
          };
          "hugo@verdienstnix.bundesheer.bigtopo" = {
            hashedPassword = "$2b$05$4aBqW68jMhwUzLWuUuYbkeKZ23uXNjBqrfLGb/iyOc2HMg4x2WrBq";
          };
        };
      };

      networking.firewall.allowedTCPPorts = [
        25
        587
        993
        143
      ];
    };
}
