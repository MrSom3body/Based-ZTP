locals {
  new_networks = {
    ZTP_LAN1 = 681
    ZTP_LAN2 = 682
  }

  existing_networks = {
    VLAN423-INET         = 423
    VLAN421-RemoteAccess = 421
  }

  all_networks = merge(
    { for k, v in vsphere_distributed_port_group.new_port_groups : k => v },
    { for k, v in data.vsphere_network.existing_port_groups : k => v }
  )
}

resource "vsphere_distributed_port_group" "new_port_groups" {
  for_each                        = local.new_networks
  name                            = each.key
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id

  vlan_id = each.value
}

data "vsphere_network" "existing_port_groups" {
  for_each      = local.existing_networks
  name          = each.key
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

