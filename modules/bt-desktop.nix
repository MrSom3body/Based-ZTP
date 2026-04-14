{
  flake.modules.nixos.bt-desktop =
    { lib, ... }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      programs.firefox.enable = true;

      programs.thunderbird = {
        enable = true;
        policies = {
          ImproveSearchSuggestionsDefault = false;
          DisableAppUpdate = true;
          AccountProvisioner = false;
          # Install internal CA so Thunderbird trusts the mail server cert
          Certificates.Install = lib.optional (builtins.pathExists ./bt-pki/ca.pem) (
            toString ./bt-pki/ca.pem
          );
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
