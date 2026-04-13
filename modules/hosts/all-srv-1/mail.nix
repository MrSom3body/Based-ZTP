{ inputs, ... }:
{
  flake.modules.nixos."hosts/all-srv-1" =
    { ... }:
    {
      imports = [ inputs.simple-nixos-mailserver.nixosModules.mailserver ];

      mailserver = {
        enable = true;
        fqdn = "mail.verdienstnix.bundesheer.bigtopo";
        domains = [ "verdienstnix.bundesheer.bigtopo" ];

        certificateScheme = "selfsigned";

        loginAccounts = {
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
