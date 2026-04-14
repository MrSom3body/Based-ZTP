{ inputs, ... }:
{
  flake.modules.nixos."hosts/all-srv-1" =
    { ... }:
    {
      imports = [ inputs.simple-nixos-mailserver.nixosModules.mailserver ];

      # Mount signed certs from all-mgmt (CA key stays on all-mgmt)
      fileSystems."/var/lib/pki" = {
        device = "10.1.0.100:/var/lib/pki/signed";
        fsType = "nfs";
        options = [
          "ro"
          "nfsvers=4"
          "_netdev"
          "soft"
        ];
      };

      mailserver = {
        enable = true;
        stateVersion = 4;
        fqdn = "mail.verdienstnix.bundesheer.bigtopo";
        domains = [ "verdienstnix.bundesheer.bigtopo" ];

        x509.certificateFile = "/var/lib/pki/mail-bundle.pem";
        x509.privateKeyFile = "/var/lib/pki/mail.key";
        localDnsResolver = false;

        accounts = {
          "admin@verdienstnix.bundesheer.bigtopo" = {
            # generate with: mkpasswd -m bcrypt
            hashedPassword = "$2b$05$F3eUVyjAhS2H7x/I2orksOiS129x.N6Ny3wqVKnJto3eJICc5OOtu";
          };
          "hugo@verdienstnix.bundesheer.bigtopo" = {
            hashedPassword = "$2b$05$/kBqLP.bSET.bPamjcJcA.WwssdNjbBFoq8U5eQiu2xh.umLLmx3i";
          };
        };
      };
    };
}
