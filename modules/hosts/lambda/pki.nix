{
  flake.modules.nixos."hosts/lambda" = {
    services.nfs.server.exports = ''
      /var/lib/caddy/.local/share/caddy/pki/authorities/local  10.0.1.0/24(ro,no_subtree_check,no_root_squash) 10.0.2.0/24(ro,no_subtree_check,no_root_squash)
    '';
  };
}
