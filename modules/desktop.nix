{ lib, ... }:
{
  flake.modules.nixos.desktop = {
    # Trust the internal mail server's self-signed certificate
    security.pki.certificateFiles = lib.optionals (builtins.pathExists ./certs/mail.pem) [
      ./certs/mail.pem
    ];

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    programs.firefox.enable = true;

    programs.thunderbird = {
      enable = true;
      policies = {
        ImproveSearchSuggestionsDefault = false;
        DisableAppUpdate = true;
        AccountProvisioner = false;
        "3rdparty".Extensions."thunderbird@example.com" = { };
        EmailPreferences = {
          emailAddress = "";
          emailIncomingServer = {
            secure = true;
            hostname = "mail.verdienstnix.bundesheer.bigtopo";
            port = 993;
            type = "imap";
          };
          emailOutgoingServer = {
            secure = true;
            hostname = "mail.verdienstnix.bundesheer.bigtopo";
            port = 587;
          };
        };
      };
    };
  };
}
