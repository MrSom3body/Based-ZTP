ubuntu_vms = {
  "sigma1" = {
    computer_name = "sigma"
    cpu           = 4
    memory        = 8192
    ipv4_gateway  = "10.40.21.254"
    network_interfaces = [
      {
        network_name = "VLAN421-RemoteAccess"
        ipv4_address = "10.40.21.61"
        ipv4_netmask = 24
      },
      {
        network_name = "ZTP_LAN1"
        ipv4_address = "10.0.1.1"
        ipv4_netmask = 24
      }
    ]
    disk = [
      {
        label            = "Hard Disk 1"
        size             = 55
        thin_provisioned = true
      }
    ]
  },
  "omega1" = {
    computer_name = "omega"
    cpu           = 4
    memory        = 8192
    ipv4_gateway  = "10.40.21.254"
    network_interfaces = [
      {
        network_name = "VLAN421-RemoteAccess"
        ipv4_address = "10.40.21.60"
        ipv4_netmask = 24
      },
      {
        network_name = "ZTP_LAN1"
        ipv4_address = "10.0.1.254"
        ipv4_netmask = 24
      },
      {
        network_name = "ZTP_LAN2"
        ipv4_address = "10.0.2.254"
        ipv4_netmask = 24
      }
    ]
    disk = [
      {
        label            = "Hard Disk 1"
        size             = 55
        thin_provisioned = true
      }
    ]
  },
  "lambda1" = {
    computer_name = "lambda"
    cpu           = 4
    memory        = 8192
    ipv4_gateway  = "10.40.21.254"
    network_interfaces = [
      {
        network_name = "VLAN421-RemoteAccess"
        ipv4_address = "10.40.21.62"
        ipv4_netmask = 24
      },
      {
        network_name = "ZTP_LAN2"
        ipv4_address = "10.0.2.1"
        ipv4_netmask = 24
      }
    ]
    disk = [
      {
        label            = "Hard Disk 1"
        size             = 55
        thin_provisioned = true
      }
    ]
  },
}
