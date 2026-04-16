{ lib, ... }:
{
  # Mounts lambda's Caddy CA cert via NFS and adds it to the system trust store.
  # On first boot (before NFS is available) the trust store entry is simply skipped.
  flake.modules.nixos.infra-pki = {
    fileSystems."/var/lib/caddy-pki" = {
      device = "10.0.2.10:/var/lib/caddy/.local/share/caddy/pki/authorities/local";
      fsType = "nfs";
      options = [
        "ro"
        "nfsvers=4"
        "soft"
        "timeo=30"
        "_netdev"
      ];
    };

    security.pki.certificateFiles = lib.optional (builtins.pathExists /var/lib/caddy-pki/root.crt) /var/lib/caddy-pki/root.crt;
  };
}
