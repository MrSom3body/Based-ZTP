{
  # Adds the internal CA to the system trust store on all BigTopo hosts.
  # After the first deploy of all-mgmt, copy the CA cert into the repo:
  #   scp root@10.1.0.100:/var/lib/pki/ca.pem modules/pki/ca.pem
  flake.modules.nixos.bt-pki =
    { lib, ... }:
    {
      security.pki.certificateFiles = lib.optional (builtins.pathExists ./ca.pem) ./ca.pem;
    };
}
